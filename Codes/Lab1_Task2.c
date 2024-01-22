#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

typedef struct StudentInfo
{
    char name[10000];
    long long studentID;
    long age;
    char department[10000];
    char bloodGroup[10000];
} Info;

typedef struct Grade
{
    long long int id;
    float gpa;
    int semester;

} gradefile;

int x=0,g=0;
gradefile List1[10000];
Info List2[10000];

int main()
{
///1st file read
    FILE* fp;
    fp=fopen("E:\\Download\\CSE 4308\\grades.txt","r");
    if(fp==NULL)
    {
        printf("Error in opening file");
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



    ///2nd file read

    FILE* p;
    p=fopen("E:\\Download\\CSE 4308\\studentInfo.txt","r");
    if(p==NULL)
    {
        printf("Error in opening 2nd file");
        return 0;
    }
    else
    {
        char temp2[10000];
        while(fscanf(fp,"%s",temp2)!=EOF)
        {
            char S_ID[100]= {'\0'};
            char S_name[10]= {'\0'};
            char S_age[15]= {'\0'};
            char S_bloodGroup[10]= {'\0'};
            char S_department[10]= {'\0'};
            long StudentID;
            long Age;


            int j=0;
            int i=0;
            while(temp2[j]!=';')
            {
                S_ID[i]=temp2[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp2[j]!=';')
            {
                S_name[i]=temp2[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp2[j]!=';')
            {
                S_age[i]=temp2[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp2[j]!=';')
            {
                S_bloodGroup[i]=temp2[j];
                i++;
                j++;
            }
            i=0;
            j++;
            while(temp2[j]!='\0')
            {
                S_department[i]=temp2[j];
                i++;
                j++;
            }
            sscanf(S_ID,"%lld",&List2[g].studentID);
            sscanf(S_name,"%s", List2[g].name);
            sscanf(S_age,"%ld",&List2[g].age);
            sscanf(S_bloodGroup,"%s",List2[g].bloodGroup);
            sscanf(S_department,"%s",List2[g].department);
            g++;
        }
    }
    fclose(p);

    ///append
    FILE* f;
    f=fopen("E:\\Download\\CSE 4308\\grades.txt","a");

    if(f==NULL)
    {
        printf("Error in opening file");
        return 0;
    }
    else
    {
        bool check=false;
        long long STUDENT_ID;
        float STUDENT_GPA;
        int STUDENT_SEMESTER;
        scanf("%lld %f %d",&STUDENT_ID,&STUDENT_GPA,&STUDENT_SEMESTER);
        for(int i=0; i<g ; i++)
        {
            if(STUDENT_ID==List2[i].studentID)
            {
                check=true;
            }
        }

        if(check)
        {
            if(STUDENT_GPA<2.50 || STUDENT_GPA>4.00)
            {
                printf("GPA is out of range");
                return 0;
            }
            else if(STUDENT_SEMESTER<1 || STUDENT_SEMESTER>8)
            {
                printf("Semester out of range");
                return 0;
            }
            for(int i=0; i<x ; i++)
            {
                if(STUDENT_ID==List1[i].id && List1[i].semester==STUDENT_SEMESTER)
                {
                    printf("GPA for semester already exists");
                    return 0;
                }
            }

            fprintf(f,"%lld;%.2f;%d\n",STUDENT_ID,STUDENT_GPA,STUDENT_SEMESTER);
        }
        else
        {
            printf("Student ID not found");
            return 0;
        }

    }
    fclose(f);
return 0;

}
