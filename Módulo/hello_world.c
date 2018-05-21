#include<linux/module.h>
#include<linux/kernel.h>
#include<linux/init.h>

MODULE_LICENSE("GPL");

MODULE_AUTHOR("Cazajous Miguel A.");

MODULE_DESCRIPTION("Módulo básico");

static int hello_world_init(void){
	printk(KERN_ALERT "Hello World!\n");
	return 0;
}

static void hello_world_exit(void){
	printk(KERN_ALERT "Goodbye World!\n");
}

module_init(hello_world_init);
module_exit(hello_world_exit);

