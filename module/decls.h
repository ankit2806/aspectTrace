//proc file name
#define PROCFS_NAME "func"
#define PROCFS_MAIN "main"
#define PROCFS_XTRA "xtra"

//global pid number
extern int _pid;

//to read file form /proc
int procfile_read(char *buffer, char **buffer_location, off_t offset, int buffer_length, int *eof, void *data);
int procfile_read_main(char *buffer, char **buffer_location, off_t offset, int buffer_length, int *eof, void *data);

//to write to file in /proc
int procfile_write(struct file *file, const char *buffer, unsigned long count, void *data);
int procfile_write_main(struct file *file, const char *buffer, unsigned long count, void *data);

//to print messages
void print_err(char *msg, char *str);
void print_msg(char *msg, char *str);
void print_data(char *msg);
void print_data_int(int val);
void print_data_lint(long int val);
void print_data_llint(long long int val);
void print_msg_int(char *msg, unsigned long int val);
void print_msg_size_int(char *msg, unsigned long int val);
char* get_strr(unsigned long int val);

//for task_struct
void find_task(void);
void find_task_func(void);
void find_task_main(void);
void get_mem(struct task_struct *task);
void get_mem_func(struct task_struct *task);
void get_mem_main(struct task_struct *task);
