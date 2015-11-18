
import Foundation

var triviaQuestions : [triviaQuestion] = []

class triviaQuestion {
    
    var Key : Int
    var Question : String
    var Answer : String
    var WrongAnswer : String
    var WrongAnswer2 : String
    
    init(){
        self.Key = 0
        self.Question = ""
        self.Answer = ""
        self.WrongAnswer = ""
        self.WrongAnswer2 = ""
    }
    
    init(Key : Int, Question : String, Answer : String, WrongAnswer : String, WrongAnswer2 : String){
        self.Key = Key
        self.Question = Question
        self.Answer = Answer
        self.WrongAnswer = WrongAnswer
        self.WrongAnswer2 = WrongAnswer2
    }
    
    func getKey() -> Int {
        return Key
    }
    
    func getAnswer() -> String {
        return Answer
    }
    
    func getQuestion() -> String {
        return Question
    }
    
    func getWrongAnswer() -> String {
        return WrongAnswer
    }
    
    func getWrongAnswer2() -> String {
        return WrongAnswer2
    }
    
    func getRandomAnswerArray() -> [String]{
        // will randomize the order of the trivia questions answers
        
        
        var answers : [String] = [] //set up answer array
        answers.append(Answer)
        answers.append(WrongAnswer)
        answers.append(WrongAnswer2)
        
        var rand1 : [String] = []
        //append to the random array in random order and then return the result
        while(rand1.count != answers.count){
            let rand = Int(arc4random_uniform(UInt32(answers.count)))
            if(rand1.contains(answers[rand]) != true){
                rand1.append(answers[rand])
            }
        }
        return rand1
    }
    
    
    
}