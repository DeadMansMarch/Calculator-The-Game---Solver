//
//  Solver.swift
//  Calculator Game
//
//  Created by Liam Pierce on 7/18/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation


class Solver{
    
    func EXCLAIM(PATH:[Button],start:Double){
        print("GOTTEN");
        print(start,terminator:" ");
        var Iter = start;
        /*
        for b in PATH{
            var button = b;
            Iter = button.Operation(Input: Iter);
            print(Iter,terminator:" ");
        }
 */
        print();
        print("================");
        for button in PATH{
            print("B : \(button.getID()), IN: \(button.LIN), OUT: \(button.LOP)");
        }
        print("================");
    }
    
    func lastMemSet(_ Log:[Button])->(Int?,Int){
        var CMEM = 0;
        for i in (0..<Log.count).reversed(){
            if Log[i].TYPE == .MEMSTORE && Log[i].MEM != nil{
                
                return (Log[i].MEM,i);
            }
        }
        return (nil, -1);
    }
    
    func trueMoves(_ Log:[Button])->Int{
        var i = 0;
        for Button in Log{
            if Button.TYPE != .MEMSTORE{
                i += 1;
            }
        }
        return i;
    }
    
    private static func DIGIFORM(_ Input:Double)->[String]{
        return String(abs(Int(Input))).characters.map{String($0)}.reversed();
    }
    
    static func Portal(_ Input:Double,PORTALS:[Int])->Double?{
        if (Button.filter(Input, true)){
            return nil;
        }
        
        let DIGIT = Solver.DIGIFORM(Input);
        var FINAL = Int(Input);
        if (DIGIT.count >= PORTALS[0] && PORTALS[0] != 0){
            let ADD =  Int(DIGIT[PORTALS[0] - 1])!;
            var NFI = String(FINAL);
            NFI.characters.remove(at: NFI.index(NFI.startIndex, offsetBy: DIGIT.count - PORTALS[0]));
            FINAL = Int(NFI)!;
            FINAL += ADD * Int(pow(Double(10),Double(PORTALS[1] - 1)));
            
        }else{
            return Input;
        }
        
        return Portal(Double(FINAL),PORTALS: PORTALS);
    }
    
    private func NOL(TYPE:Interpretor.ActionType)->Bool{
        switch(TYPE){
        case .FADD:
            return true;
        default: break;
        }
        return false;
    }

    func Solve(){
        let decompose = Interpretor.MParse();
        let moves = decompose[0];
        let start = decompose[1];
        let goal = decompose[2];
        let Buttons = Interpretor.BParse();
        let PActive = true;
        
        let PORTALS:[Int];
        if PActive {
            PORTALS = Interpretor.PParse();
        }else{
            PORTALS = [0,0];
        }
        
        var LEVELADEB = [String]();
        var LEVELBDEB = [String]();
        var LEVELADICT = [String:Double]();
        
        var LEVELA = [Double]();
        var LEVELAPATH = [[Button]]();
        var LEVELB = [Double]();
        var LEVELBPATH = [[Button]]();
        
        var MOVES = [Int]();
        var PATH = [Button]();
        
        
        for b in Buttons{
            var bM = b;
            LEVELA = [Double]();
            LEVELAPATH = [[Button]]();
            LEVELB = [Double]();
            LEVELBPATH = [[Button]]();
            LEVELADICT = [String:Double]();
            MOVES = [Int]();
            
            if (bM.TYPE != .MEMSTORE){
                MOVES.insert(1,at:0);
            }else{
                MOVES.insert(0,at:0)
            }
            
            if (bM.MatchRequirements(start)){
                print("Initial button is now : \(bM.getID())");
                let DIN = Solver.Portal(bM.Operation(Input: start), PORTALS: PORTALS);
                if (DIN != nil){
                    LEVELA.append(DIN!);
                    LEVELAPATH.append([bM]);
                    LEVELADEB.append(bM.getID());
                }
            }else{ continue; }
            if (moves > 1){
            
        
        var BLOCK = 0;
        while LEVELA.count > 0{
            var LMAXB = 0;
            var MOVES_TEMP = [Int]();
            for i in 0..<LEVELA.count{
                BLOCK = 0;
                if (MOVES[i] >= Int(moves)){ continue; }
                let SETC = LEVELA[i];
                for b in 1...Buttons.count{
                    
                    var LBLOK = false;
                    var GRAB:[Button] = LEVELAPATH[i];
                    var BUTTON = Buttons[b - 1];
                    
                    let BINDEX = LMAXB - BLOCK + b - 1; //Always fresh index in B.
                    
                    MOVES_TEMP.insert(MOVES[i] + 1,at:BINDEX);
                    
                    BUTTON.SMULS = GRAB.reduce(0,{$1.FAD + $0});
                    
                    if BUTTON.TYPE == .MEMPRINT || BUTTON.TYPE == .MEMSTORE{
                        let MEMBANK = self.lastMemSet(GRAB).0;
                        if (MEMBANK == nil){
                            print("MEM NIL");
                        }
                        BUTTON.MEM = MEMBANK;
                        if (BUTTON.TYPE == .MEMSTORE){
                            MOVES_TEMP[BINDEX] -= 1;
                        }
                    }
                    
                    if (BUTTON.MatchRequirements(SETC)){
                        let OP = BUTTON.Operation(Input: SETC);
                        if (BINDEX < 0){
                            print(BINDEX,BLOCK);
                        }
                        let PSOL = Solver.Portal(OP,PORTALS:PORTALS);
                        if let PSOLVE = PSOL{
                            LEVELB.insert(PSOLVE,at:BINDEX);
                            GRAB.append(BUTTON);
                            LEVELBDEB.insert(LEVELADEB[i] + "[\(BUTTON.getID())]",at:BINDEX);
                            LEVELBPATH.insert(GRAB,at:BINDEX);
                            
                            if PSOL == goal {
                                PATH = GRAB;
                                print("MATCHED")
                                break;
                            }
                        }else{
                            LBLOK = true;
                        }
                    }else{
                        LBLOK = true;
                    }
                    
                    if (LBLOK){
                        BLOCK += 1;
                    }
                }
                LMAXB = LMAXB - BLOCK + Buttons.count;
                if !PATH.isEmpty{
                    break;
                }
                
            }
            
            MOVES = MOVES_TEMP;
            LEVELADEB = LEVELBDEB;
            LEVELBDEB = [String]();
            
            for i in 0..<LEVELADEB.count{
                LEVELADICT[LEVELADEB[i]] = LEVELB[i];
            }
            
            LEVELA = LEVELB;
            LEVELAPATH = LEVELBPATH
            LEVELBPATH = [[Button]]();
            LEVELB = [Double]();
            
            if !PATH.isEmpty{
                break;
            }
        }
        }
        if (!PATH.isEmpty){
            self.EXCLAIM(PATH:PATH,start:start);
            return;
        }
        
    }
        
    }
}
