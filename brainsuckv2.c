#include <stdio.h>
#include <stdlib.h>

char code[20000] = ">++++++[<++++++++>-]+++..";
char memory[3000];
int mem = 0, code_pointer = 0;

int main()
{

    while (code[code_pointer] != 0)
    {

        char c = code[code_pointer];

        if (c == '>')
            mem++;
        else if (c == '<')
            mem--;
        else if (c == '.')
            printf("%c", memory[mem]);
        else if (c == ',')
            scanf("%c", memory[mem]);
        else if (c == '+')
            memory[mem]++;
        else if (c == '-')
            memory[mem]--;
        else if (c == '[' && !memory[mem])
        {   
            int it = code_pointer;
            char open = 1;
            while (open)
            {
                if (++it == 20000)
                    printf("wyjebalo za array");
                if (code[code_pointer] == '[')
                    open++;
                if (code[code_pointer] == ']')
                    open--;
            }
        }
        else if (c == ']' && memory[mem])
        {
            char close = 1;
            while (close)
            {
                if (--code_pointer == -1)
                    printf("wyjebalo za array");
                if (code[code_pointer] == ']')
                    close++;
                if (code[code_pointer] == '[')
                    close--;
            }
        }

        code_pointer++;
        
    }
    printf("\n");
}