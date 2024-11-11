# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [Katherine Li] 
* *email:* [ktjli@ucdavis.edu]
___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Works perfectly; camera follows target with cross drawn when draw_camera_logic is true. Superspeed works perfectly as well; camera stays locked on target when moving in all directions whether superspeed or not.
___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Works perfectly; all exported fields work as they should. Camera pushes the target when it hits the left side of the box. Box shows when draw_camera_logic is on and goes away when not. Speed of the autoscroll can be adjusted on the x and z axes and the camera continues to push the target as it should. The bounds of the box can also be adjusted on the appropriate vertices and size of the box changes as expected. Superspeed also works here; the target movement works with superspeed within the box.
___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera movement works perfectly; lerps smoothly to the targets position when input stops and follows behind when target is moving. When target goes too far off screen, camera jumps to its position instead of following smoothly. Superspeed works perfectly with those same conditions. Camera position cross mostly works, but when zoomed in, disappears when camera enters the yellow parts of the map and reappears when it exits those parts of the map. Catchup speed, leash, and follow speed can be adjusted as desired and work perfectly after adjusting.  
___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
When input is made, camera does stay in front of target as expected and smoothly moves to be in front of it and corrects smoothly when direction changes. When leash distance gets reached, the lerp does not work and the camera doesn't center on the target position even when the target is still. All the export variables can be adjusted and the behavior changes as expected. The camera cross is drawn when draw_camera_logic is true but has the same problem as above; disappears in some parts of the map when zoomed in. 
___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera follows the target with the expected behavior. Camera does not move when target is in inner box and moves at the push ratio of target speed when in the bounds of the outer box, and at target speed when touching the outer bounds. When touching the corners, it moves at target speed in both directions. The outer box behavior (moving at target speed) happens when the target isn't fully touching the drawn box; there is a small gap. When the target goes at superspeed, the camera box disappears even when draw_camera_logic is true. After superspeed, camera centers on target instead of targett ending up where it would have been after the superspeed (in the box on the edge of the direction target was moving). The exported fields change the behavior as expected; new box draws properly, push ratio speed adjusts as expected.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####

___
#### Put style guide infractures ####

___

# Best Practices #


#### Best Practices Infractions ####
* [comment left behind](https://github.com/ensemble-ai/exercise-2-camera-control-ccc2d8850/blob/b9e71584e9375f49ca04c8109507db2f4e0f4922/Obscura/scripts/camera_controllers/four_way_speedup_push_zone.gd#L89) - comment left behind that prints when target is touching corners that prints to console while program runs; causes a lot of console print statements that may cause issues on slower computers
* 

#### Best Practices Exemplars ####
