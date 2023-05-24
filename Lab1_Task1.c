#include<stdio.h>
#include<stdlib.h>

typedef struct Grade
{
    long long int id;
    float gpa;
    int semester;

} gradefile;

int x=0;
gradefile List1[10000];

int main()
{

    FILE* fp;
    fp=fopen("E:\\Download\\CSE 4308\\grades.txt","r");
    if(fp==NULL)
    {
        printf("Error in opening input file");
        return 0;
    }
    else
    {
        char temp[100000];
        while(fscanf(fp,"%s",temp)!=EOF)
        {
            long long int student_id;
            float student_gpa;
            int student_semester;
            char ID[10000]= {'\0'};
            char GPA[10000]= {'\0'};
            char SEMESTER[10000]= {'\0'};
            int i=0,j=0;

            while(temp[j]!=';')
            {
                ID[i]=temp[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp[j]!=';')
            {
                GPA[i]=temp[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp[j]!='\0')
            {
                SEMESTER[i]=temp[j];
                i++;
                j++;
            }
            sscanf(ID,"%lld",&student_id);
            sscanf(GPA,"%f",&student_gpa);
            sscanf(SEMESTER,"%d",&student_semester);
            List1[x].id=student_id;
            List1[x].gpa=student_gpa;
            List1[x].semester=student_semester;
            x++;
        }

    }
    fclose(fp);
    float MaxGpa = 0;
    int k;
    for(int i=0; i<x ; i++)
    {
        if(List1[i].gpa>MaxGpa)
        {
            MaxGpa=List1[i].gpa;
            k=i;
        }

    }

    printf("Student ID  of who has maximum GPA is : %lld",List1[k].id);


    return 0;
}
