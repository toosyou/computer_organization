#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag;
    int last_time;
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int associativity, int cache_size, int block_size, const char *file_name){
	//miss rate
	int number_lookup = 0;
	int number_miss = 0;

	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size/associativity);
	int line= 1 << index_bit;

	cache_content **cache =new cache_content*[line];
    for(int i=0;i<line;++i){
        cache[i] = new cache_content[associativity];
    }
	//cout<<"cache line:"<<line<<endl;

	for(int j=0;j<line;j++)
        for(int k=0;k<associativity;++k)
            cache[j][k].v=false;

  	FILE *fp=fopen(file_name,"r");					//read file

	while(fscanf(fp,"%x",&x)!=EOF){
		//cout<<hex<<x<<" " <<dec;
        //cout.flush();
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);

        bool hit = false;
        for(int i=0;i<associativity;++i){
            if( cache[index][i].v && cache[index][i].tag == tag ){ // hit
                hit = true;
                cache[index][i].last_time = number_lookup;
                break;
            }
        }

        if(!hit){ // miss
            number_miss++;

            int find_empty = false;
            for(int i=0;i<associativity;++i){
                if( cache[index][i].v == false ){
                    find_empty = true;
                    cache[index][i].v = true;
                    cache[index][i].tag = tag;
                    cache[index][i].last_time = number_lookup;
                    break;
                }
            }
            if(find_empty == false){
                int min_time = 99999;
                int index_min = -1;

                for(int i=0;i<associativity;++i){
                    if(min_time > cache[index][i].last_time){
                        min_time = cache[index][i].last_time;
                        index_min = i;
                    }
                }
                cache[index][index_min].v = true;
                cache[index][index_min].tag = tag;
                cache[index][index_min].last_time = number_lookup;
            }

        }
		number_lookup++;
	}
	fclose(fp);

	cout << endl;
	cout << "file_name:\t" << file_name <<endl;
    cout << "associativity:\t" << associativity <<endl;
	cout << "cache_size:\t" << cache_size <<endl;
	cout << "block_size:\t" << block_size <<endl;
	cout << "number_lookup:\t" << number_lookup << endl;
	cout << "number_miss:\t" << number_miss <<endl;
	cout << "miss rate:\t" << (double)number_miss/(double)number_lookup <<endl;
	cout <<endl;

    for(int i=0;i<line;++i){
        delete [] cache[i];
    }
	delete [] cache;
}

int main(){
	char file_name[2][11]={"LU.txt", "RADIX.txt"};
	// Let us simulate 4KB cache with 16B blocks
    int block_size = 64;
    for(int i=0;i<2;++i){
        for(int associativity=1;associativity < 16;associativity*=2){
            for(int cache_size=1*K;cache_size<64*K;cache_size*=2){
                simulate(associativity, cache_size, block_size, file_name[i]);
            }
        }
    }

	return 0;
}
