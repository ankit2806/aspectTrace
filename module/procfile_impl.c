//file to read and write to the proc file: "test_mem"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/uaccess.h>
#include "decls.h"

int _pid;

//max buffer size of the proc file
#define PROCFS_MAX_SIZE 1024

//buffer used to store the character for this module
static char procfs_buffer[PROCFS_MAX_SIZE];

//buffer size
static unsigned long procfs_buffer_size = 0;

//flag to get _pid
int flag = 0;

//function to convert string to integer
int _getint(const char *str)
{
	int pid, str_len, i;
	
	str_len = strlen(str);
	
	for(i=0, pid=0;i<str_len;i++)
	{
		int index,j;
		
		for(j=0, index=1;j<str_len-i-1;j++)
			index = index * 10;
		
		pid = pid+(str[i]-48)*index;
	}
	
	return pid;
}

//function is called when /proc file is read

int procfile_read(char *buffer, char **buffer_location, off_t offset, int buffer_length, int *eof, void *data)
{
	int ret;
	
	//print_msg("procfile_read is called: /proc/", PROCFS_NAME);
	
	if(offset > 0)
		ret = 0;	//we have finished to read the file
	else
	{
		//fill the buffer, return the buffer size
		memcpy(buffer, procfs_buffer, procfs_buffer_size);
		ret = procfs_buffer_size;
	}
	
	return ret;
}

int procfile_write(struct file *file, const char *buffer, unsigned long count, void *data)
{
	procfs_buffer_size = count;	//get buffer size
	
	if(procfs_buffer_size > PROCFS_MAX_SIZE)
		procfs_buffer_size = PROCFS_MAX_SIZE;	
	
	//write data to buffer
	if(copy_from_user(procfs_buffer, buffer, procfs_buffer_size))
	{
		return -EFAULT;
	}
	
	//to get the pid number from the proc file
	switch(flag)
	{
		case 0: printk(KERN_INFO "hiii\n");_pid = _getint(buffer);
			flag = 1; find_task_func();
			break;
		default:  _pid = _getint(buffer);
			flag = 1; find_task_func();
			break;
	}
	
	return procfs_buffer_size;
}
