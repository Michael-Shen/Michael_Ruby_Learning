class Some	
	#instance method
	def a
 		puts "this is called by an instance method,self is #{self}"
	end	
	#class method
	def Some.a    # or "def self.a"
		puts "this is called by an class method,self is #{self}"
	end	
end
obj1=Some.new
obj1.a  #this is called by an instance method,self is #<SomeL0x1e3c958>
Some.a  #this is called by an class method,self is Some

########## Ways to add instance method to a dedicated object #####
# way1 singleton method
def obj1.a2
	puts "singleton method for adding instance method for obj1.a2"
end
obj1.a2
# way2 Anonymous singleton class
class<< obj1
	def a3
		puts "Anonymous singleton class for adding instance method for obj1.a3"
	end
end
obj1.a3
########## Ways to add additional class method to a existing Class ####
# 在Ruby中，所有東西都是物件，類別也是物件，具體來說，類別是Class實例，
# 既然類別是物件，也就可以為Class的實例定義單例方法

# way1 Anonymous singleton class
class << Some  #Some 被視為object
	def a2   # a2 為object Some 的instance method
		puts "this is called by an class method a2"
	end
end
Some.a2  #呼叫object Some的 insance method
# way2 singleton method
def Some.a3   # Some 被視為object,a3 為object Some 的instance method
	puts "this is called by an class method a3"
end
Some.a3 #呼叫object Some的 insance method
class Some
	puts "self is #{self}"  #self is Some
	class << self  # Some為object, 增加其instance method
		def a4
			puts "this is called by an class method a4"
		end
	end	
	def a5 #Some 的 class method
		puts "called by instance method a5"
	end
end
Some.a4    	#this is called by an class method a4(implement by instance method of Some)
#Some.a5 	#undefined method a5
obj2=Some.new #
#obj2.a4   	#undefined method a4  ; 因為a4為object Some的instance method
obj2.a5    	#called by instance method a5
