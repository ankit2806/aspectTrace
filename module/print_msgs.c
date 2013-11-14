//file to print the messages

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/tty.h>
#include <linux/tty_driver.h>

void print_err(char *msg, char *str)
{
	struct tty_struct *my_tty;
	
	my_tty = current->signal->tty;	//tty for the current task
	
	if(my_tty != NULL)
	{
		((my_tty->ops) -> write) (my_tty, msg, strlen(msg));	
		((my_tty->ops) -> write) (my_tty, str, strlen(str));
		
		((my_tty->ops) -> write) (my_tty, "\015\012", 2);
		
	}
}

void print_msg(char *msg, char *str)
{
	struct tty_struct *my_tty;
	
	my_tty = current->signal->tty;	//tty for the current task
	
	if(my_tty != NULL)
	{
		((my_tty->ops) -> write) (my_tty, msg, strlen(msg));	
		((my_tty->ops) -> write) (my_tty, str, strlen(str));
		
		((my_tty->ops) -> write) (my_tty, "\015\012", 2);
		
	}
}

void print_msg_int(char *msg, unsigned long int val)
{
	struct tty_struct *my_tty;
	int i, j, tot_digit, r;
	char c;
	unsigned long tmp;
	
	my_tty = current->signal->tty;	//tty for the current task

	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg1[tot_digit+3];
	
	tmp = val;
	
	msg1[0]='0';
	msg1[1]='x';
	i=2;
	
	while(tmp>0)
	{
		r = tmp%16;
		if(r < 10)
			msg1[i] = r+48;
		else if(r==10)
			msg1[i] = 'a';
		else if(r==11)
			msg1[i] = 'b';
		else if(r==12)
			msg1[i] = 'c';
		else if(r==13)
			msg1[i] = 'd';
		else if(r==14)
			msg1[i] = 'e';
		else if(r==15)
			msg1[i] = 'f';
		i++;
		tmp/=16;
	}
	msg1[i]='\0';
	
	j=2;
	r=i/2;
	while(r>0)
	{
		c = msg1[i-1];
		msg1[i-1] = msg1[j];
		msg1[j] = c;
		i--;
		r--;
		j++;
	}
	
	
	/*
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg1[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg1[tot_digit]='\0';*/
	
	if(my_tty != NULL)
	{
		((my_tty->ops) -> write) (my_tty, msg, strlen(msg));
		((my_tty->ops) -> write) (my_tty, msg1, strlen(msg1));
		
		((my_tty->ops) -> write) (my_tty, "\015\012", 2);
		
	}
}

void print_msg_size_int(char *msg, unsigned long int val)
{
	struct tty_struct *my_tty;
	int i, j, tot_digit, r;
	char c;
	unsigned long tmp;
	
	my_tty = current->signal->tty;	//tty for the current task

	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg1[tot_digit+3];
	
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg1[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg1[tot_digit]='\0';
	
	if(my_tty != NULL)
	{
		((my_tty->ops) -> write) (my_tty, msg, strlen(msg));
		((my_tty->ops) -> write) (my_tty, msg1, strlen(msg1));
		
		((my_tty->ops) -> write) (my_tty, "\015\012", 2);
		
	}
}

void print_data(char *msg)
{
	struct tty_struct *my_tty;
	
	my_tty = current->signal->tty;	//tty for the current task
	
	if(my_tty != NULL)
	{
		((my_tty->ops) -> write) (my_tty, msg, strlen(msg));
		
		((my_tty->ops) -> write) (my_tty, "\015\012", 2);
		
	}
}

void print_data_int(int val)
{
	int i, tmp, tot_digit;
	
	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg[tot_digit+1];
	
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg[tot_digit]='\0';
	
	print_data(msg);
}

void print_data_lint(unsigned long int val)
{
	int i, tot_digit;
	
	unsigned long tmp;
	
	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg[tot_digit+1];
	
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg[tot_digit]='\0';
	
	print_data(msg);
}

void print_data_llint(long long int val)
{
	int i, tmp, tot_digit;
	
	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg[tot_digit+1];
	
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg[tot_digit]='\0';
	
	print_data(msg);
}

char* get_strr(unsigned long int val)
{
	int i, tot_digit;
	
	unsigned long tmp;
	
	tmp = val;
	
	for(tot_digit=0;tmp>0;)
	{
		tmp/=10;
		tot_digit++;
	}
	
	char msg[tot_digit+1];
	
	for(i=tot_digit-1,tmp=val;i>=0;i--)
	{
		msg[i] = (tmp%10)+48;
		tmp/=10;
	}
	
	msg[tot_digit]='\0';
	
	return msg;
}
