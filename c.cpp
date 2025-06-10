#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern "C"{
    void asmMain(void);
    int readLine(char *dest, int maxLen);
};
int readLine(char *dest, int maxLen){
    char *result = fgets(dest, maxLen, stdin);
    if(result != NULL){
        int len = strlen(result);
        if(len > 0){
            dest[len - 1] = 0;
        }
        return len;
    } 
    return -1;
}
int main(void){
    try{
        printf("running programm.\n");
        asmMain();
        printf("terminated successfuly\n");
    }catch(...){
        printf("Error.\n");
    }
} 