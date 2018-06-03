/***************************************************************************//**
@file         Bash.h
@author       Stephen Brennan
@date         Thursday,  8 January 2015
@brief        LSH (Libstephen SHell)
*******************************************************************************/
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define die(e) do { fprintf(stderr, "%s\n", e); exit(EXIT_FAILURE); } while (0);
#define LSH_RL_BUFSIZE 1024
#define LSH_TOK_BUFSIZE 64
#define LSH_TOK_DELIM " \t\r\n\a"
#define directorio_actual 500
#define BUFFSIZE 256

char output[BUFFSIZE];
int nbytes;

/**
   @brief Main entry point.
   @param argc Argument count.
   @param argv Argument vector.
   @return status code
 */

 /*
   List of builtin commands, followed by their corresponding functions.
  */
char *builtin_str[] = {
  "cd",
  "help",
  "exit"
};

int lsh_num_builtins() {
  return sizeof(builtin_str) / sizeof(char *);
}

 /**
    @brief Bultin command: change directory.
    @param args List of args.  args[0] is "cd".  args[1] is the directory.
    @return Always returns 1, to continue executing.
  */
int lsh_cd(char **args){
  if (args[1] == NULL) {
   fprintf(stderr, "lsh: expected argument to \"cd\"\n");
  } else {
   if (chdir(args[1]) != 0) {
     perror("lsh");
   }
  }
  return 1;
}

 /**
    @brief Builtin command: print help.
    @param args List of args.  Not examined.
    @return Always returns 1, to continue executing.
  */
int lsh_help(char **args){
  int i;
  printf("Stephen Brennan's LSH\n");
  printf("Type program names and arguments, and hit enter.\n");
  printf("The following are built in:\n");

  for (i = 0; i < lsh_num_builtins(); i++) {
   printf("  %s\n", builtin_str[i]);
  }

  printf("Use the man command for information on other programs.\n");
  return 1;
}

 /**
    @brief Builtin command: exit.
    @param args List of args.  Not examined.
    @return Always returns 0, to terminate execution.
  */
int lsh_exit(char **args){
   return 0;
}

int (*builtin_func[]) (char **) = {
  &lsh_cd,
  &lsh_help,
  &lsh_exit
};
 /**
   @brief Launch a program and wait for it to terminate.
   @param args Null terminated list of arguments (including program).
   @return Always returns 1, to continue execution.
  */
int lsh_launch(char **args){
  pid_t pid;/*, wpid;*/
  int link[2];

  if (pipe(link)==-1)
   die("pipe");

  if ((pid = fork()) == -1)
   die("fork");

  if (pid == 0) {
   dup2(link[1],STDOUT_FILENO);
   close(link[0]);
   close(link[1]);
   execvp(args[0], args);
   die("execl");
  }
  else {
   close(link[1]);
   nbytes=read(link[0],output, sizeof(output));
   wait(NULL);
  }

  return 0;
}

 /**
    @brief Execute shell built-in or launch program.
    @param args Null terminated list of arguments.
    @return 1 if the shell should continue running, 0 if it should terminate
  */
int lsh_execute(char **args){
  int i;

  if (args[0] == NULL) {
   /* An empty command was entered.*/
   return 0;
  }

  for (i = 0; i < lsh_num_builtins(); i++) {
   if (strcmp(args[0], builtin_str[i]) == 0) {
     return (*builtin_func[i])(args);
   }
  }

  return lsh_launch(args);
}

int main(int argc, char **argv){
  int status, i;
  FILE *file;

  do {
    for(i=0; i<argc; i++){
      argv[i]=argv[i+1];
    }
    status = lsh_execute(argv);

    file=fopen("output","w");
    fprintf(file, "%s\n", output);
    fclose(file);
  } while (status);

  return EXIT_SUCCESS;
}
