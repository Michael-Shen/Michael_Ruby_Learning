# gem install narray
# narray version : 0.6.0.9   # gem list 
# https://github.com/princelab/narray/wiki/Tentative-NArray-Tutorial


require 'narray' 

arr = NArray.int(3,3)
arr[1,1] = 7
puts arr.shape.to_s
puts arr.inspect
puts arr.class

puts "##############################"
#z = NArray.int(4,3).fill!(5)
z = NArray.int(4,3).random!(1000)
puts z.inspect

puts "##############################"
y= NArray.int(3,4).indgen!
puts y.inspect
print y.to_a.to_s + "\n"  # [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]]
puts y.min(0).inspect   #[0,3,6,9] ; 0 means each row
puts y.min(1).inspect	#[0,1,2]   ; 1 means each column


puts "##############################"

b= NArray[[1, 0, 0], [0, 1, 2]]
puts b.shape.to_s  #[3,2]
puts b.inspect

puts b.size #6
puts b.typecode  # 3 ==> int
puts b.dim     # 2 ==>dimension

puts "##############################"
a = NArray[20,30,40,50]
b = NArray.int(4).indgen!
c = a-b
print c.to_a.to_s  + "\n"   #  [ 20, 29, 38, 47 ]

#puts "hello"
puts c.min(0).inspect
puts c.max
puts c.sum


### Indexing, Slicing and Iterating
a = NArray.int(10).indgen!**3
#=> NArray.int(10): 
  #[ 0, 1, 8, 27, 64, 125, 216, 343, 512, 729 ]
puts a.inspect
puts a[2] #8
puts a[2...5].inspect # [8,27,64]

a.each{|i| puts i}    # iterator ! 
# collect back into an NArray
# note that 'map' is currently undefined
c = a.collect {|v| v + 7 }

class NArray
    def from_function!(level=0, indices=[], &block)
      if level < shape.size
        (0...(shape[level])).each do |s|
          new_indices = indices.dup
          new_indices << s
          self[*new_indices] = block.call(new_indices) if new_indices.size == shape.size
          from_function!(level+1, new_indices, &block)
        end
      end
      self
    end
  end
  
  
b = NArray.int(4,5).from_function! {|x,y| 10*y+x }
puts b.inspect
  #=> NArray.int(4,5): 
  #[ [ 0, 1, 2, 3 ], 
  #  [ 10, 11, 12, 13 ], 
  #  [ 20, 21, 22, 23 ], 
  #  [ 30, 31, 32, 33 ], 
  #  [ 40, 41, 42, 43 ] ]

puts b[3,2]  #23

# true means all the values across that dimension
puts b[1,true].inspect
#  => NArray.int(5): 
#  [ 1, 11, 21, 31, 41 ]

# note that slice does the same thing as brackets, but PRESERVES THE RANK!!!
puts b.slice(1,true).inspect

puts b[true, 1..2].inspect  # ranges are okay of course
#=> NArray.int(4,2): 
#  [ [ 10, 11, 12, 13 ], 
#   [ 20, 21, 22, 23 ] ]

puts b[false,-1].inspect  # equivalent to b[true,-1]
#=> NArray.int(4): 
#  [ 40, 41, 42, 43 ]

d=a.dup        # Deep copy
e=a             
f=NArray[ 0, 1, 8, 27, 64, 125, 216, 343, 512, 729 ]
puts d.inspect 
puts a.object_id #688200 
puts d.object_id #644932
puts a.equal?(d) #false ; compare object_id
puts a.equal?(e) #true  ; compare object_id
puts a.equal?(f) #false ; compare object_id
puts "true" if a.eql?(d)  # true ;compare content
puts "true" if a.eql?(e)  # true ;compare content
puts "true" if a.eql?(f)  # true ;compare content

arr1=[1,2,3]
arr2=[1,2,3]
puts "eql" if arr1.eql?(arr2)     #eql
puts "eqal" if arr1.equal?(arr2)  #not equal

#require 'enumerator'
  class NArray
	include Enumerable
	
    # returns all the indices to access the values of the NArray.  if start == 1,
    # then the first dimension (row) values are not returned, if start == 2,
    # then the first two dimensions are skipped.
    #
    # if a block is provided, the indices are yielded one at a time
    # [obviously, this could be made into a fast while loop instead of
    # recursive ... someone have at it]
    def indices(start=0, ar_of_indices=[], final=[], level=shape.size-1, &block)
      if level >= 0
        (0...(shape[level])).each do |s|
          new_indices = ar_of_indices.dup
          new_indices.unshift(s)
          if (new_indices.size == (shape.size - start))
            block.call(new_indices)
            final << new_indices 
          end
          indices(start, new_indices, final, level-1, &block)
        end
      end
      final
    end

    # returns an enumerator that yields each row of the NArray
    def by_row
      Enumerator.new do |yielder|
        indices(1) do |ind|
          yielder << self[true, *ind]
        end
      end
    end
  end

 b.by_row.each {|row| p row }
 
 
 ###############
#The shape of an array can be changed with various commands:

 c = NArray[ [[0,1,2],[10,12,13]], [[100,101,102], [110,112,113]] ]
 c.flatten!       # flatten
 puts c.to_a.to_s
 
 puts c.class
 c.reshape!(2,6)  # reshape
 puts c.inspect
 puts c.to_a.to_s
 
 