#include<iostream>

#include<string>

using namespace std;

#define MVNum 100

#define OK 1

#define ERROR 0

#define MaxInt 100

typedef string VerTexType;

typedef int Status;

typedef int SElemType;

typedef struct {

SElemType* base;

SElemType* top;

int stacksize;

}SqStack;

typedef struct ArcNode {

int adjvex;

struct ArcNode* nextarc;

}ArcNode;

typedef struct VNode {

VerTexType data;

ArcNode* firstarc;

}VNode, AdjList[MVNum];

typedef struct {

int vexnum, arcnum;

AdjList vertices;

}ALGraph;

int indegree[MVNum];//记录各顶点入度

int topo[MVNum];//记录拓扑排序结点顺序

Status InitStack(SqStack& S) {//创建并初始化栈

S.base = new SElemType[MaxInt];

if (!S.base) return ERROR;

S.top = S.base;

S.stacksize = MaxInt;

return OK;

}

Status StackEmpty(SqStack S) {//判空
if (S.top == S.base) return OK;

return ERROR;

}

Status Push(SqStack& S, SElemType e) {//入栈

if (S.top - S.base == S.stacksize) return ERROR;

*S.top = e;

S.top++;

return OK;

}

Status Pop(SqStack& S, SElemType& e) {//出栈

if (S.base == S.top) return ERROR;

S.top--;

e = *S.top;

return OK;

}

int LocateVex(ALGraph G, VerTexType v) {//返回结点的下标

for (int i = 0; i < G.vexnum; i++) {

if (G.vertices[i].data == v)

return i;

}

return -1;

}

void CreateUDG(ALGraph& G) {//创建邻接矩阵

cout << "请输入结点个数和边的个数：" << endl;

cin >> G.vexnum >> G.arcnum;

cout << "请输入各个结点的名称：" << endl;

for (int i = 0; i < G.vexnum; i++) {

cin >> G.vertices[i].data;

G.vertices[i].firstarc = NULL;//初始化表结点

}

cout << "请输入各个有向边：" << endl;

for (int k = 0; k < G.arcnum; k++) {

VerTexType v1, v2;

cin >> v1 >> v2;

int i = LocateVex(G, v1);

int j = LocateVex(G, v2);

ArcNode* p1 = new ArcNode;

p1->adjvex = j;

p1->nextarc = G.vertices[i].firstarc;//头插法创建邻接矩阵

G.vertices[i].firstarc = p1;

}

}

void FindInDegree(ALGraph G, int indegree[]) {//统计结点入度
for (int i = 0; i < G.vexnum; i++) {

int cnt = 0;//存储邻接点域为i的结点个数

for (int j = 0; j < G.vexnum; j++) {

ArcNode* p = new ArcNode;//定义指向各个边结点的指针

p = G.vertices[j].firstarc;

while (p) {//当p不为空继续循环

if (p->adjvex == i)//当某边结点邻接点域等于结点i时，入度+1

cnt++;

p = p->nextarc;

}

indegree[i] = cnt;//将计数结果保留在indegree数组中

}

}

}

Status TopologicalSort(ALGraph G, int topo[]) {//判断是否有环

FindInDegree(G, indegree);//求出各结点的入度

SqStack S;

InitStack(S);//初始化栈

for (int i = 0; i < G.vexnum; i++) {

if (!indegree[i]) Push(S, i);//入度为0者进栈

}

int m = 0;//对入度为0结点出栈计数

while (!StackEmpty(S)) {

int i = 0;

Pop(S, i);

topo[m] = i;//将结点i保存在拓扑序列数组topo中

++m;

ArcNode* p = new ArcNode;

p = G.vertices[i].firstarc;//从结点i的第一个邻接点开始，将结点i的所有邻接

点入度-1

while (p != NULL) {

int k = p->adjvex;

--indegree[k];//入度-1

if (indegree[k] == 0) Push(S, k);//若入度减为0，则入栈

p = p->nextarc;

}

}

if (m < G.vexnum) {

cout << "该有向图中有环" << endl;

return ERROR;//该有向图有回路

}

else return OK;

}
void PrintResult(ALGraph G) {//输出拓扑排序的结果

if (TopologicalSort(G, topo)) {

for (int i = 0; i < G.vexnum; i++) {

cout << G.vertices[topo[i]].data << " ";

}

}

}

int main() {

ALGraph G;

CreateUDG(G);

PrintResult(G);

return 0;

}
