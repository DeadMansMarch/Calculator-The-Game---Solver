//
//  Button.swift
//  Calculator Game
//
//  Created by Liam Pierce on 7/18/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation
import Darwin;

extension String {
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var searchRange: Range<String.Index>?
        var count = 0
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            count += 1
        }
        return count
    }
}

struct Button:CustomStringConvertible{
    let TYPE:Interpretor.ActionType;
    var ID:String = "NONE";
    var FACTORS = [Double]();
    var FACTORSS = [String]();
    
    static var AllowDouble = true;
    static var REMOVEFILLER = true;
    
    var LOP = 0.0;
    var LIN = 0.0;
    
    var SMULS = 0; // SET BY SOLVER;
    
    var FAD = 0; // SET BY HACKER;
    
    var MEM:Int? = nil; // SET BY SELF
    
    init(Type:Interpretor.ActionType,Factor:[Double]){
        self.TYPE = Type;
        self.FACTORS = Factor;
        
        if Type == .FADD{
            self.FAD = Int(Factor[0]);
        }
    }
    
    init(Type:Interpretor.ActionType,Factor:[String]){
        self.TYPE = Type;
        self.FACTORSS = Factor;
    }
    
    init(Type:Interpretor.ActionType){
        self.TYPE=Type;
    }
    
    mutating func loadID(ID:String){
        self.ID = ID;
    }
    
    func F(_ Of: Int)->Double{
        return FACTORS[Of] + Double(SMULS);
    }
    
    static func filter(_ Input:Double,_ ForceDoubleProtection:Bool = false)->Bool{
        
        if abs(Input) > Double(pow(Double(10),Double(6))){
            return true;
        }
        
        if (Double(Int(Input))) != Input{
            if ForceDoubleProtection || !AllowDouble{
                return true;
            }
        }
        return false;
    }
    
    func MatchRequirements(_ Input:Double)->Bool{
        if Button.filter(Input,true){
            return false;
        }
        
        if Button.REMOVEFILLER {
            if rmFiller(Input){
                return false;
            }
        }
        
        switch(TYPE){
        case .replacement:
            return String(Int(Input)).countInstances(of: FACTORSS[0]) > 0;
        case .MEMPRINT:
            return self.MEM != nil;
        default:
            return true;
        }
    }
    
    func rmFiller(_ Input:Double)->Bool{
        switch(TYPE){
        case .mirror:
            return false;
        case .MEMSTORE:
            if (self.MEM != nil){
                if (self.MEM! == Int(Input)){
                    return true;
                }
            }
        default:
            return false;
        }
        return false;
    }
    
    mutating func Operation(Input:Double)->Double{
        self.LIN = Input;
        let OP = Operator(Input: Input);
        self.LOP = OP;
        return OP;
    }

    mutating private func Operator(Input:Double)->Double{
        let MUL = Input >= 0 ? 1.0 : -1.0
        
        switch(TYPE){
        case .multiplication:
            return Input * F(0);
        case .appendation:
            let Digits = String(abs(Int(F(0)))).characters.count;
            
            return (abs(Input) * Double(pow(Double(10),Double(Digits))) + F(0)) * MUL;
        case .remove:
            let LastDigit = Int(String(describing:String(Int(Input)).characters.last!));
            return (Input - Double(LastDigit!)) / 10;
        case .square:
            return Input * Input;
        case .subtraction:
            return Input - F(0);
        case .addition:
            return Input + F(0);
        case .replacement:
            return Double(String(Int(Input)).replacingOccurrences(of: FACTORSS[0], with: FACTORSS[1]))!;
        case .division:
            return Input / F(0);
        case .flop:
            return Input * -1;
        case .reverse:
            
            return Double(String(String(abs(Int(Input))).characters.reversed()))! * MUL;
            
        case .sum:
            if (Double(Int(Input)) == Input){
                return Double(String(abs(Int(Input))).characters.map{Int(String($0))!}.reduce(0,{$0 + $1})) * MUL;
            }else{
                return 0;
            }
        case .cube:
            return Input * Input * Input;
        case .wleft:
            
            let First = String(abs(Int(Input))).characters.first!;
            return Double(String(String(abs(Int(Input))).characters.dropFirst()) + String(First))! * MUL;
        case .wright:
            
            let Last = String(abs(Int(Input))).characters.last!;
            return Double(String(Last) + String(String(abs(Int(Input))).characters.dropLast()))! * MUL;
        case .mirror:
            let FULL = String(abs(Int(Input)));
            return Double(FULL + String(FULL.characters.reversed()))! * MUL;
        case .FADD:
            return Input; // Complete ignore : All that matters is the storage of multipliers.
        case .MEMSTORE:
            self.MEM = Int(Input);
            return Input;
        case .MEMPRINT: //Mem will be set by solver.
            let reMem = self.MEM!;
            return Double((String(abs(Int(Input))) + String(abs(reMem))))! * MUL;
        case .inv:
            let INTER = String(abs(Int(Input))).characters.map({String($0) != "0" ? String(10 - Int(String($0))!) : "0"})
            return Double(INTER.reduce("",{$0 + $1}))!;
        default:
            print("ERROR : No Type Match");
        }
        return 0;
    }
    
    func getID()->String{
        if Interpretor.SYMBOLS[self.TYPE] != nil{
            return Interpretor.SYMBOLS[self.TYPE]! + "\(Int(self.FACTORS[0] + Double(self.SMULS)))";
        }
        return self.ID;
    }
    
    var description:String{
        return self.getID();
    }
    
}
