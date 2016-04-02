//import Cocoa
//import Fou    ndation

var pancakes: Array = [8, 1, 6, 7, 2]
/**
//Just seeing if I remember stuff
func exchange<T>(data : T[], i: Int, j:Int)
{
    let temp = data[i]
    data[i] = data[j]
    data[j] = temp
}

func invert<T>(data: T[])
{
    for i in 0..data.count {
        if i != (data.count - 1) - i {
            exchange(data, i, (data.count - 1) - i)
        }
    }
}
*/

//WHY THE HELL AREN'T THE NEXT TWO LINES WORKING ???
//invert(pancakes)
//pancakes

func indexOfLargestElement<T: Comparable>(inArray array: [T]) -> Int
{
    var indexOfLargestElement: Int = -1
    if !array.isEmpty {
        indexOfLargestElement = 0
        for index in (1..<array.count) {
            if array[indexOfLargestElement] < array[index] {
                indexOfLargestElement = index
            }
        }
    }

    return indexOfLargestElement
}

func subArray<T>(ofArray array: [T], withRange range: Range<Int>) -> Array<T>
{
    var returnArray: Array = [T]()
    if !array.isEmpty {
        for index in range {
            returnArray.append(array[index])
        }
    }
    
    return returnArray
}

func flip<T>(flipIndex: Int, array: [T]) -> [T] {
    var returnArray = array
//    If index is less than number of elements
    if flipIndex < returnArray.count && !returnArray.isEmpty {
//        Create temp array of pancakes to flip
        var pileToFlip = [T]()
//        Iterate over pancakes
        for (index, element) in returnArray.enumerate() {
//            Till spatula is reached append to temp array
            pileToFlip.append(element)
            if index == flipIndex {
//                On reaching spatula, reverse temp array to flip
                pileToFlip = pileToFlip.reverse()
                for i in (0...index).reverse() {
//                    Copy values to original array and break
                    returnArray[i] = pileToFlip[i]
                }
                break
            }
        }
    }
    return returnArray
}

func pancakeSort<T: Comparable>(pile: [T]) -> [T] {
    var sortingPile = pile
    if !sortingPile.isEmpty {
        for i in (0..<sortingPile.count).reverse() {
            if indexOfLargestElement(inArray: subArray(ofArray: sortingPile, withRange: 0..<i)) != 0 {
                sortingPile = flip(indexOfLargestElement(inArray: subArray(ofArray: sortingPile, withRange: 0..<i)), array: sortingPile)
            }
            sortingPile = flip(i, array: sortingPile)
        }
    }
    return sortingPile
}

pancakes = pancakeSort(pancakes)
pancakes

/*

var final = T[]()
var elementsToSort = subArray(ofArray: pile, withRange: 0..pile.count)

while !elementsToSort.isEmpty {
var currentIndex = indexOfLargestElement(inArray: elementsToSort)

if currentIndex == elementsToSort.endIndex {
continue
}
else if currentIndex == 0 {
flip(elementsToSort.endIndex, elementsToSort)
}
else {
flip(indexOfLargestElement(inArray: elementsToSort), elementsToSort)
flip(elementsToSort.endIndex, elementsToSort)
}
final.append(elementsToSort.removeLast())
elementsToSort
}
final
*/
