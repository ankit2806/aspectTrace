#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <asm/uaccess.h>
#include "decls.h"

static struct proc_dir_entry *my_proc_file;
static struct proc_dir_entry *my_proc_main;
static struct proc_dir_entry *my_proc_xtra;

int init_module()
{
	my_proc_file = create_proc_entry(PROCFS_NAME, 0777, NULL);
	my_proc_main = create_proc_entry(PROCFS_MAIN, 0777, NULL);
	my_proc_xtra = create_proc_entry(PROCFS_XTRA, 0777, NULL);
	
	if(my_proc_file == NULL)
	{
		remove_proc_entry(PROCFS_NAME, 0);
		print_err("Error could not initialize /proc/", PROCFS_NAME);
		return -ENOMEM;
	}
	
	my_proc_file->read_proc = procfile_read;
	my_proc_file->write_proc = procfile_write;
	my_proc_file->mode = S_IFREG | S_IRUGO;
	my_proc_file->uid = 0;
	my_proc_file->gid = 0;
	my_proc_file->size = 37;
	
	if(my_proc_main == NULL)
	{
		remove_proc_entry(PROCFS_MAIN, 0);
		print_err("Error could not initialize /proc/", PROCFS_MAIN);
		return -ENOMEM;
	}
	
	my_proc_main->read_proc = procfile_read_main;
	my_proc_main->write_proc = procfile_write_main;
	my_proc_main->mode = S_IFREG | S_IRUGO;
	my_proc_main->uid = 0;
	my_proc_main->gid = 0;
	my_proc_main->size = 37;
	
	if(my_proc_xtra == NULL)
	{
		remove_proc_entry(PROCFS_XTRA, 0);
		print_err("Error could not initialize /proc/", PROCFS_XTRA);
		return -ENOMEM;
	}
	
	my_proc_xtra->read_proc = procfile_read;
	my_proc_xtra->write_proc = procfile_write;
	my_proc_xtra->mode = S_IFREG | S_IRUGO;
	my_proc_xtra->uid = 0;
	my_proc_xtra->gid = 0;
	my_proc_xtra->size = 37;
	
	print_msg("Created file: /proc/",PROCFS_NAME);
	print_msg("Created file: /proc/",PROCFS_MAIN);
	print_msg("Created file: /proc/",PROCFS_XTRA);
	
	return 0;
}

void cleanup_module()
{
	remove_proc_entry(PROCFS_NAME, 0);
	print_msg("Deleted file: /proc/", PROCFS_NAME);
}
