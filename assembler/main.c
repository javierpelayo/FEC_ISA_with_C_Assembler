#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *fileREAD;
    FILE *fileOUT;
    FILE *fileOUTDB;
    char *filenameREAD = "prog1.txt"; // name of your txt file
    char *filenameOUT = "machinecode.txt";
    char *filenameOUTDB = "machinecodeDB.txt";
    char line[1024]; // assuming lines in the file do not exceed 1023 characters
    // char *line = malloc(1024);
    char *lineCPY;
    char *delimiter; // Space as a delimiter
    char *tokenOP;
    char *tokenPARS;

    char *OPCode;
    char *pars;
    char *par1;
    char *par2;

    char *MCOPCode;
    char *MCpar1;
    char *MCpar2;
    char *MC;

    int cntr = 0;
    int lineNum = 1;

    // Open the file in read mode
    fileREAD = fopen(filenameREAD, "r");

    // Read and print each line
    while (fgets(line, sizeof(line), fileREAD) != NULL) {
        fileOUT = fopen(filenameOUT, "a");
        fileOUTDB = fopen(filenameOUTDB, "a");

        lineCPY = (char *) malloc(1025);
        delimiter = malloc(50);

        OPCode = malloc(50);
        pars = malloc(50);
        par1 = malloc(50);
        par2 = malloc(50);

        MCOPCode = malloc(50);
        MCpar1 = malloc(50);
        MCpar2 = malloc(50);
        MC = malloc(50);

        strcpy(lineCPY, line);

        if (fileREAD == NULL || fileOUT == NULL) {
            fprintf(stderr, "ERROR: Unable to open the file\n");
            return 1; // exit with an error code
        }

        strcpy(delimiter, " ");
        cntr = 0;
        tokenOP = strtok(lineCPY, delimiter);
        
        // parse OPCode and Pars
        while (tokenOP != NULL) {
            if(cntr == 0) {
                strcpy(OPCode, tokenOP);
            } else if (cntr == 1){
                strcpy(pars, tokenOP);
            }

            cntr = cntr + 1;
            tokenOP = strtok(NULL, delimiter);
        }

        // Find OPCode
        if (strcmp(OPCode, "MOV") == 0) {
            strcpy(MCOPCode, "000");
        } else if (strcmp(OPCode, "ADDI") == 0) {
            strcpy(MCOPCode, "001");
        } else if (strcmp(OPCode, "STR") == 0) {
            strcpy(MCOPCode, "010");
        } else if (strcmp(OPCode, "LDR") == 0) {
            strcpy(MCOPCode, "011");
        } else if (strcmp(OPCode, "PAR") == 0) {
            strcpy(MCOPCode, "1000");
        } else if (strcmp(OPCode, "AND") == 0) {
            strcpy(MCOPCode, "1001");
        } else if (strcmp(OPCode, "EOR") == 0) {
            strcpy(MCOPCode, "1010");
        } else if (strcmp(OPCode, "CMP") == 0) {
            strcpy(MCOPCode, "1100");
        } else if (strcmp(OPCode, "BNE") == 0) {
            strcpy(MCOPCode, "1101");
        } else if (strcmp(OPCode, "BLT") == 0) {
            strcpy(MCOPCode, "1110");
        } else if (strcmp(OPCode, "RST") == 0) {
            strcpy(MCOPCode, "1111");
        } else if (strcmp(OPCode, "ROT") == 0) {
            strcpy(MCOPCode, "1011");
        } else {
            printf("ERROR: Syntax Error in OP code. \nLine Num: %d\n", lineNum);
        }

        cntr = 0;
        strcpy(delimiter, ",");
        tokenPARS = strtok(pars, delimiter);
        
        // parse OPCode and Pars
        while (tokenPARS != NULL) {
            if(cntr == 0) {
                strcpy(par1, tokenPARS);
            } else if (cntr == 1){
                strcpy(par2, tokenPARS);
            }

            cntr = cntr + 1;
            tokenPARS = strtok(NULL, delimiter);
        }

        // par1 = DDD
        // par2 = SSS or SS or XX
        // e.g. ROT X2,NP (singular dest)


        // par1

        if(strcmp(par1, "X0") == 0) {
            strcpy(MCpar1, "000");
        } else if(strcmp(par1, "X1") == 0) {
            strcpy(MCpar1, "001");
         } else if(strcmp(par1, "X2") == 0) {
            strcpy(MCpar1, "010");
        } else if(strcmp(par1, "X3") == 0) {
            strcpy(MCpar1, "011");
        } else if(strcmp(par1, "X4") == 0) {
            strcpy(MCpar1, "100");
        } else if(strcmp(par1, "X5") == 0) {
            strcpy(MCpar1, "101");
        } else if(strcmp(par1, "X6") == 0) {
            strcpy(MCpar1, "110");
        } else if(strcmp(par1, "X7") == 0) {
            strcpy(MCpar1, "111");
        } else {
            printf("ERROR: Syntax Error in destination param.\nLine Num: %d\n", lineNum);
        }

        // par2 - SSS or SS or XX

        if (strcmp(MCOPCode, "001") == 0) {
            if(strcmp(par2, "3\n") == 0) {
                strcpy(MCpar2, "011");
            } else if(strcmp(par2, "2\n") == 0) {
                strcpy(MCpar2, "010");
            } else if(strcmp(par2, "1\n") == 0) {
                strcpy(MCpar2, "001");
            } else if(strcmp(par2, "0\n") == 0) {
                strcpy(MCpar2, "000");
            } else if(strcmp(par2, "-1\n") == 0) {
                strcpy(MCpar2, "111");
            } else if(strcmp(par2, "-2\n") == 0) {
                strcpy(MCpar2, "110");
            } else if(strcmp(par2, "-3\n") == 0) {
                strcpy(MCpar2, "101");
            } else if(strcmp(par2, "-4\n") == 0) {
                strcpy(MCpar2, "100");
            } else {
                printf("ERROR: Syntax Error in source param. (valid immediatew values for ADDI operation :[-4,3]).\nLine Num: %d\n", lineNum);
            }
        } else if(strcmp(MCOPCode, "000") == 0 || strcmp(MCOPCode, "010") == 0 || strcmp(MCOPCode, "011") == 0) {
            if(strcmp(par2, "X0\n") == 0) {
                strcpy(MCpar2, "000");
            } else if(strcmp(par2, "X1\n") == 0) {
                strcpy(MCpar2, "001");
            } else if(strcmp(par2, "X2\n") == 0) {
                strcpy(MCpar2, "010");
            } else if(strcmp(par2, "X3\n") == 0) {
                strcpy(MCpar2, "011");
            } else if(strcmp(par2, "X4\n") == 0) {
                strcpy(MCpar2, "100");
            } else if(strcmp(par2, "X5\n") == 0) {
                strcpy(MCpar2, "101");
            } else if(strcmp(par2, "X6\n") == 0) {
                strcpy(MCpar2, "110");
            } else if(strcmp(par2, "X7\n") == 0) {
                strcpy(MCpar2, "111");
            } else if(strcmp(par2, "NP\n") == 0) {
                strcpy(MCpar2, "00");
            } else {
                printf("ERROR: Syntax Error in source param. (OP code: 000 to 011).\nLine Num: %d\n %s %s %s \n", lineNum, OPCode, par1, par2);
            }
        } else if (strcmp(MCOPCode, "1001") == 0 || strcmp(MCOPCode, "1010") == 0 || strcmp(MCOPCode, "1100") == 0 || strcmp(MCOPCode, "1101") == 0 || strcmp(MCOPCode, "1110") == 0 ) {
            if(strcmp(par2, "X0\n") == 0) {
                strcpy(MCpar2, "00");
            } else if(strcmp(par2, "X1\n") == 0) {
                strcpy(MCpar2, "01");
            } else if(strcmp(par2, "X2\n") == 0) {
                strcpy(MCpar2, "10");
            } else if(strcmp(par2, "X3\n") == 0) {
                strcpy(MCpar2, "11");
            } else {
                printf("ERROR: Syntax Error in source param. (OP code: 1000 to 1110).\nLine Num: %d\n %s %s %s \n", lineNum, OPCode, par1, par2);
            }        
        } else if(strcmp(MCOPCode, "1011") == 0 || strcmp(MCOPCode, "1111") == 0 || strcmp(MCOPCode, "1000") == 0) {
            strcpy(MCpar2, "00");
        } else {
            printf("ERROR: Error in machine code, no matches found.\nLine Num: %d\n", lineNum);
        }

        if(strcmp(par2, "NP\n") == 0) {
            strcpy(MCpar2, "00");
        } 

        // concat machine code
        // MC = MCOPCode + par2 + par1
        strcat(MC,MCOPCode);
        strcat(MC,MCpar2);
        strcat(MC,MCpar1);
        // strcat(MC, "\n");

        fprintf(fileOUT, "%s", MC);
        fprintf(fileOUT, "\n");

        // strcat(MC, line);

        // write to file
        fprintf(fileOUTDB, "%s", MCOPCode);
        fprintf(fileOUTDB, " ");
        fprintf(fileOUTDB, "%s", MCpar2);
        fprintf(fileOUTDB, " ");
        fprintf(fileOUTDB, "%s", MCpar1);
        fprintf(fileOUTDB, " :: ");
        fprintf(fileOUTDB, "%s", line);

        free(OPCode);
        free(pars);
        free(lineCPY);

        free(MC);
        free(MCOPCode);
        free(MCpar1);
        free(MCpar2);
        free(par1);
        free(par2);
        free(delimiter);

        fclose(fileOUT); // Close the file
        fclose(fileOUTDB); // Close the file
        lineNum++;
    }

    fclose(fileREAD); // Close the file

    return 0; // exit without error
}
