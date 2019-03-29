# The Magic Conch Shell - Project Planning

## a) Description

The Magic Conch Shell is a web application where users can ask 'ANY' questions by using points (in app currency), and users signed up as mentors can answer the question to earn points.

### Summary of Features

* The points are transferrable to money and can be purchased as well.

* The mentors will be lined up in a queue and each of them will have categories of their profession where they can answer the best.

* Users who asked the question can select the answer that was posted by the mentors, or pass the answer

* They can also rate the mentor's answer, after selecting or passing the answer received

* Users can see the list of questions/answers they posted or received

* Users can see the payment/earnings history, their ratings and points

### Team Members: Scott Donelly, Yunsung Oh

### Target Audience

* People who are looking for an answer to a specific questions, or need consultation/discussion about a matter, but cannot find appropriate answer/mentor on popular search engines (e.g. Google) or in their contact list who can be reached immediately

### Detailed Functionalities

* Users, questions, answers, ratings, tags (categories) will be stored in PostgreSQL database

* Users can register, log in, log out with bcrypt
  * They have to be logged-in to access all the features

* On the user profile page, users can see their:
  * Total points, and payment/earnings history from the points
  * Status as a mentor, and their overall ratings
  * List of questions they asked
    * With an answer to the question if applicable, and whether the question was solved
  * List of answers they provided, and whether the answer was selected or passed
  * List of 'tags' (categories) they are associated with, if they are mentors

* Users can ask question by typing, or using speech to text feature using a microphone
  * They can provide an optional title, and are required to provide at least one 'tag' to the question
  * They are required to pay a specified points to ask a question
  * The posted question will then enter into a 'queue', and will be answered as 'first-come-first-serve'
  * They will be notified if an answer was posted to their questions
  * Then, they have options to 'select' the answer and close the question, or 'pass' the answer to get in the queue again for a different answer
  * Once they select or pass, they can provide rating to the answer depending on how useful it was

* Mentors can provide an answer to the question and earn points if their answer is selected
  * Mentors will get into a queue as well, and the first category from the mentor queue will be connected to the matching first category of the question in the queue
  * Therefore, mentors will take turn answering a question they are connected, waiting for selection status and ratings
  * Stretch Goal: the 'asker', and the 'answerer' can comment on the answer posted for clarification

* Users can apply to be a mentor
  * If they are a mentor, they can associate themselves with tags they can give a professional answer
  * Mentors can have many tags and will be only matched to a question with their tags
  * Stretch Goal: If no mentor with a question's tag is online, starting from the front of the mentor queue, ask them if they want to try answer the question, and let users know it is not from the mentor's expertise
  * Mentors can see their answers' ratings specific to the answer


## b) User Story

* As a User,
  * I want to post my question,
  * Because I want to get an answer

* As a User,
  * I want to select/pass the answer to my question,
  * Because I think the answer is satisfying/not helpful

* As a User,
  * I want to rate the answer,
  * Because I want to let other users know about the mentor's ability

* As a User,
  * I want to transfer points to money (vice-versa),
  * Because I need to buy more points/earn money from points

* As a User,
  * I want to be able to view my question/answer history,
  * Because I often need to review the answer I found

* As a User,
  * I want to be able to view my payment/earning history,
  * Because I need to plan my income/expenses

* As a User,
  * I want to become a mentor,
  * Because I want to earn points by answering questions

* As a User,
  * I want to be notified when I get an answer,
  * Because I do not like to be constantly checking for if I got one

* As a Mentor,
  * I want to see the rating of my answer,
  * Because I want to know how well I am doing and reflect on it

* As a Mentor,
  * I want to be notified when I am matched to a question
  * Because I do not like to be constantly checking for if I got a match

