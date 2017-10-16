//
//  Interpretor.swift
//  Calculator Game
//
//  Created by Liam Pierce on 7/18/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

class Interpretor{
    var GOAL = 0;
    static var SYMBOLS:[ActionType:String] = [.subtraction:"-",.multiplication:"x",.division:"/",.addition:"+"];
    
    enum ActionType{
        case multiplication,subtraction,appendation,remove,square,addition,replacement,division,flop,reverse,sum,cube,wleft,wright,mirror,F,FADD,MEMSTORE,MEMPRINT,inv;
    }
    
    public static func BParse()->[Button]{
        print("Input each button present :");
        var BUTTONS = [Button]();
        while let Input = readLine(){
            if (Input == ""){
                break;
            }
            var TYPE:ActionType;
            var FACTORS = [Double]();
            
            switch(String(describing:Input.characters.first!)){
                case "-":
                    TYPE = .subtraction;
                case "<":
                    TYPE = .remove;
                case "^":
                    if (Input == "^2"){
                        TYPE = .square;
                    }else{
                        TYPE = .cube;
                    }
                case "/":
                    TYPE = .division;
                case "x":
                    TYPE = .multiplication;
                case "r":
                    TYPE = .reverse;
                case "s":
                    TYPE = .sum;
                case "m":
                    if (Input == "mirror"){
                        TYPE = .mirror;
                    }else if (Input == "mem"){
                        var b_s = Button(Type:.MEMSTORE);
                        var b_w = Button(Type:.MEMPRINT);
                        b_s.loadID(ID: "STORE");
                        b_w.loadID(ID: "WRITE");
                        BUTTONS.append(b_s);
                        BUTTONS.append(b_w);
                        TYPE = .MEMPRINT
                        continue;
                    }else{
                        TYPE = .F
                    }
                
                case "w":
                    if Input == "w<"{
                        TYPE = .wleft;
                    }else{
                        TYPE = .wright;
                    }
                case "[":
                    let IN = Input.substring(to: Input.index(Input.startIndex, offsetBy: 3));
                    if IN == "[+]"{
                        TYPE = .FADD;
                    }else{
                        TYPE = .F
                }
                case "i":
                    TYPE = .inv;
                
                default:
                    if (Input == "+-"){
                        TYPE = .flop;
                        break;
                    }else if (String(describing:Input.characters.first!) == "+"){
                        TYPE = .addition;
                        break;
                    }
                    if Input.contains(">>"){
                        TYPE = .replacement;
                        break;
                    }else{
                        TYPE = .appendation;
                        break;
                    }
                
                
            }
            
            switch(TYPE){
            case .remove:
                break;
            case .replacement:
                let FACTORS_S = Input.characters.split(separator: ">").filter{String($0) != ""}.map{String($0)};
                
                var BUTTON = Button(Type:TYPE,Factor:FACTORS_S);
                BUTTON.loadID(ID: Input);
                BUTTONS.append(BUTTON);
                continue;
            case .square:
                break;
            case .cube:
                break;
            case .appendation:
                FACTORS.insert(Double(Input)!,at:0);
            case .flop:
                break;
            case .reverse:
                break;
            case .sum:
                break;
            case .FADD:
                FACTORS.insert(Double(String(Input.characters.dropFirst(3)))!,at:0);
                
            case .wleft: break;
            case .wright: break;
            case .mirror: break;
            case .inv: break;
            default:
                FACTORS.append(Double(String(Input.characters.dropFirst()))!);
            }
            var BUTTON = Button(Type:TYPE,Factor:FACTORS);
            BUTTON.loadID(ID: Input);
            BUTTONS.append(BUTTON);
        }
        return BUTTONS;
    }
    
    public static func getInput(Prompt:String,CheckType:String = "Double",AllowBlank:Bool = false, Terminator:String = "")->String{
        print(Prompt,terminator: Terminator);
        while let Input = readLine(){
            if (Input == ""){
                continue;
            }
            if (CheckType != ""){
                switch(CheckType){
                    case "Double":
                        if Double(Input) != nil{ return Input };
                    default:
                        return Input;
                    
                }
                print("Error in input type.");
            }else{
                return Input;
            }
        }
        return "ERROR";
    }
    
    public static func MParse()->[Double]{
        let Moves = getInput(Prompt: "Number of Moves : ");
        let Goal = getInput(Prompt: "Goal : ");
        let Start = getInput(Prompt:"Start : ");
        return [Double(Moves)!,Double(Start)!,Double(Goal)!];
    }
    
    public static func PParse()->[Int]{
        let In = getInput(Prompt: "Portal In : ");
        if (In == ""){
            return [0,0];
        }
        let Out = getInput(Prompt: "Portal Out: ");
        return [Int(In)!,Int(Out)!];
    }
}
