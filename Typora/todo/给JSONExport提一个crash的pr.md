给JSONExport提一个crash的pr

`FileRepresenter.swift`文件 482行，如果`lang.basicTypesWithSpecialFetchingNeedsTypeCast`为nill，将会crash



​          // if needs cast

​          **var** cast = ""

​          **if** lang.basicTypesWithSpecialFetchingNeedsTypeCast != **nil** {

​            cast = lang.basicTypesWithSpecialFetchingNeedsTypeCast[index]

​          }

