//
//  NewViewController.swift
//  FirstAid
//
//  Created by Ернур Сункарбек on 31.08.16.
//  Copyright © 2016 Ернур Сункарбек. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UICollisionBehaviorDelegate {
    

    let data = ["Шаг 1", "Шаг 2","Шаг 3"]
    let textViewData = ["При артериальном кровотечении кровь бьет из раны фонтаном.Остановка артериального кровотечения: - прижать пальцами или кулаком артерию; - точка прижатия должна быть выше места кровотечения - до наложения жгута держать конечность в приподнятом положении.",
        "Кровотечения останавливают:- из нижней части лица – прижатием челюстной артерии к краю нижней челюсти; - на виске и лбу – прижатием височной артерии впереди козелка уха",
        "- на голове и шее — прижатием сонной артерии к шейным позвонкам"
//    - на подмышечной впадине и плече — прижатием подключичной артерии к кости в подключичной ямке
//    - на предплечье — прижатием плечевой артерии посредине плеча с внутренней стороны
//    - на кисти и пальцах рук — прижатием двух артерий (лучевой и локтевой) к нижней трети предплечья у кисти
//    - из голени — прижатием подколенной артерии
//    - на бедре — прижатием бедренной артерии к костям таза
//    - на стопе— прижатием артерии на тыльной части стопы.
//    
//    Правила наложения жгута
//    Жгут используется только для остановки АРТЕРИАЛЬНОГО
//    кровотечения и только на КОНЕЧНОСТЯХ
//    Жгут накладывается у верхней границы на 5 см выше раны Нельзя накладывать жгут на голую кожу, положить под жгут ткань.
//    Жгут нельзя накрывать, он должен быть виден
//    На верхних конечностях жгут накладывается до 1,5 часов, на нижних - до 2 часов. По истечении времени снять жгут на 15 секунд. Дальнейшее время наложение жгута сокращается в два раза от первоначального.
//    
//    НАЛОЖЕНИЕ ЖГУТА
//    1. Завести жгут за конечность и растянуть с максимальным усилием
//    2. Прижать первый виток жгута и убедиться в отсутствии пульса
//    3. Наложить следующие витки жгута с меньшим усилием
//    4. Обернуть петлю-застежку вокруг жгута
//    5. Вложить под резинку петли записку о времени наложения жгута
//    6. Жгут на конечность можно наложить не более чем на 1 час.
//    
//    Признаки правильного наложения ЖГУТА
//    - отсутствия пульса ниже раны
//    - остановка кровотечения
//    - побледнение конечности
//    - холодная конечность.
]
    var views = [UIView]()
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var snap: UISnapBehavior!
    var previousTouchPoint: CGPoint!
    var viewDraging = false
    var viewPinned = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        
        
        var offset : CGFloat = self.view.frame.size.height - self.view.frame.size.height * 0.6
        
        for i in 0 ... data.count - 1 {
            if let view = addVC(atOffset: offset, textForHeader: data[i], textForTextView: textViewData[i]){
                views.append(view)
                offset -= 50
            }
        }
        
    }
    
    func addVC(atOffset offset:CGFloat, textForHeader data: AnyObject?, textForTextView text: AnyObject?) -> UIView? {
        
        let frameFOrView = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let stackElementVC = sb.instantiateViewControllerWithIdentifier("StackElement") as! StackedMenuViewController
        
        
        if let view = stackElementVC.view {
            view.frame = frameFOrView
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.blackColor().CGColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            if let headerStr = data as? String{
                stackElementVC.headerString = headerStr
                
            }
            
            if let textForView = text as? String{
                stackElementVC.viewString = textForView
            }
            
            
            self.addChildViewController(stackElementVC)
            self.view.addSubview(view)
            stackElementVC.didMoveToParentViewController(self)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NewViewController.handlePan(_:)))
            view.addGestureRecognizer(panGestureRecognizer)
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
            
            let boundary = view.frame.origin.y + view.frame.size.height
            //lower boundary
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundaryWithIdentifier(1, fromPoint: boundaryStart, toPoint: boundaryEnd)
            
            //upper boundary
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundaryWithIdentifier(2, fromPoint: boundaryStart, toPoint: boundaryEnd)
            
            gravity.addItem(view)
            
            let itemBehavior = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehavior)
            
            return view
        }
        return nil
    }
    
    func handlePan(gestureRecognizer : UIPanGestureRecognizer){
        
        let touchPoint = gestureRecognizer.locationInView(self.view)
        let draggedView = gestureRecognizer.view!
        
        if gestureRecognizer.state == .Began {
            let dragStartPoint = gestureRecognizer.locationInView(draggedView)
            
            if dragStartPoint.y < 200 {
                viewDraging = true
                previousTouchPoint = touchPoint
            }
        } else if gestureRecognizer.state == .Changed && viewDraging {
            let yOfset = previousTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOfset)
            previousTouchPoint = touchPoint
        } else if gestureRecognizer.state == .Ended && viewDraging {
            
            //pin
            pin(draggedView)
            
            //addVelocity
            addVelocity(toView: draggedView, fromGestoreRecognizer: gestureRecognizer)
            animator.updateItemUsingCurrentState(draggedView)
            viewDraging = false
        }
        
    }
    
    func pin(view : UIView) {
        let viewHasReachedPinLocation = view.frame.origin.y < 100
        
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                snapPosition.y += 30
                
                snap = UISnapBehavior(item: view, snapToPoint: snapPosition)
                animator.addBehavior(snap)
                
                //setVisibility
                setVisibility(view, alpha: 0)
                viewPinned = true
            }
        }else {
            if viewPinned {
                animator.removeBehavior(snap)
                
                setVisibility(view, alpha: 1)
                
                viewPinned = false
            }
        }
    }
    
    func  setVisibility(view: UIView, alpha: CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    func addVelocity(toView view: UIView, fromGestoreRecognizer panGesture: UIPanGestureRecognizer) {
        
        var velocity = panGesture.velocityInView(self.view)
        velocity.x = 0
        if let behavior = itemBehavior(forView: view) {
            behavior.addLinearVelocity(velocity, forItem: view)
        }
        
    }
    
    func itemBehavior(forView view: UIView) -> UIDynamicItemBehavior? {
        
        for behavior in animator.behaviors {
            if let itemBehavior = behavior as? UIDynamicItemBehavior {
                if let possibleView = itemBehavior.items.first as? UIView where possibleView == view {
                return itemBehavior
                }
            }
        }
        
        return nil
    }
    
//    func collisionBehior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: )
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if NSNumber(integerLiteral: 2).isEqual(identifier) {
            let view = item as! UIView
            pin(view)
        }
            
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
