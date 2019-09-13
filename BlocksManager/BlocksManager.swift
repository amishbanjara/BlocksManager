//
//  BlocksManager.swift
//  BlocksManager
//
//  Created by Amish on 13/09/19.
//  Copyright © 2019 Amish. All rights reserved.
//

import UIKit

public class BlocksManager {
    
    private var op: Operation?

    public init() {
        op = nil
        op = Operation()
    }
    
    deinit {
        op = nil
    }
    
    public init(block: (()->Void)?) {
        op = nil
        op = Operation()
        op?.completionBlock = block
    }
    
    var isFinished: Bool {
        get {
            return op != nil ? op!.isFinished : false
        }
    }
    
    var isCancelled: Bool {
        get {
            return op != nil ? op!.isCancelled : false
        }
    }
    
    public func dependency(bm: BlocksManager) {print("bm")
        addOrRemove(dependency: bm, status: true)
    }
    
    public func removeDependency(bm: BlocksManager) {
        addOrRemove(dependency: bm, status: false)
    }
    
    public func waitUnitlFinished() {
        op!.waitUntilFinished()
    }
    
    public func start(executeOnMainThread mainThread: Bool, asynchronous: Bool) {
        startExecution(mainThread: mainThread, asynchronous: asynchronous)
    }
    
    public func cancel() {
        cancelExecution()
    }

    public func addExecutionBlock(_ block: @escaping () -> Void) {
        op!.completionBlock = block
    }
}

private extension BlocksManager {
    
    func addOrRemove(dependency: BlocksManager, status: Bool) {
        
        status
            ?
                op?.addDependency(dependency.op!)
            :
                op?.removeDependency(dependency.op!)
        
    }
    
    func startMainThreadBlock(isAsync async: Bool) {
        if async {
            DispatchQueue.main.async { [weak self] in
                self?.startOP()
            }
        } else {
            DispatchQueue.main.sync { [weak self] in
                self?.startOP()
            }
        }
    }
    
    func startGloabalThreadBlock(isAsync async: Bool) {
        if async {
            DispatchQueue.global().async { [weak self] in
                self?.startOP()
            }
        } else {
            DispatchQueue.global().sync { [weak self] in
                self?.startOP()
            }
        }
    }
    
    func startExecution(mainThread: Bool, asynchronous: Bool) {
        
        mainThread
            ?
                startMainThreadBlock(isAsync: asynchronous)
            :
                startGloabalThreadBlock(isAsync: asynchronous)
    }
    
    func startOP() {
        op?.start()
    }
    
    func cancelExecution() {
        op?.cancel()
    }
    
}
