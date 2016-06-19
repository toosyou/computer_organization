#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int cache_size, int block_size, const char *file_name){
	//miss rate
	int number_lookup = 0;
	int number_miss = 0;

	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line= cache_size>>(offset_bit);

	cache_content *cache =new cache_content[line];
	//cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
		cache[j].v=false;

  	FILE * fp=fopen(file_name,"r");					//read file

	while(fscanf(fp,"%x",&x)!=EOF){
		//cout<<hex<<x<<" " <<dec;
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);
		if(cache[index].v && cache[index].tag==tag){
			cache[index].v=true; 			//hit
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
			number_miss++;
		}
		number_lookup++;
	}
	fclose(fp);

	cout << endl;
	cout << "file_name:\t" << file_name <<endl;
	cout << "cache_size:\t" << cache_size <<endl;
	cout << "block_size:\t" << block_size <<endl;
	cout << "number_lookup:\t" << number_lookup << endl;
	cout << "number_miss:\t" << number_miss <<endl;
	cout << "miss rate:\t" << (double)number_miss/(double)number_lookup <<endl;
	cout <<endl;
	delete [] cache;
}

int main(){
	char file_name[2][11]={"DCACHE.txt", "ICACHE.txt"};
	// Let us simulate 4KB cache with 16B blocks
	for(int i=0;i<2;++i){
		for(int block_size=4;block_size<64;block_size*=2){
			for(int cache_size=64;cache_size<1024;cache_size*=2){
				simulate(cache_size, block_size, file_name[i]);
			}
		}
	}
	return 0;
}
