# BiPASS

## Inspiration
After leaving my wallet at home for the 50th time, I realized there has to be a better way to conduct transactions. In today's day and age, technology companies know everything about me - my friends, my social media, my payment information, and my biometric data. With all of this information, as well as the ability to authenticate users based off of biometrics, I figured there has to be a better way to conduct transactions that doesn't rely on a clunky magnetic stripe card from the 1970s.

## What it does
It allows users to sign up for an account and save their biometric data and credit card information. At the transaction point, the software will use this data to charge the appropriate user and grant loyalty points. Businesses can sign up for the BiPASS app and create an account to receive payments from BiPASS monthly and design a loyalty program for customers. Once the loyalty semantics are created, the algorithms use these details to assign loyalty points and statuses accordingly. Businesses are able to monitor their loyalty programs right through the app, and users can track their progress in all of their programs in one easy to use place.

## How I built it
I used Swift for all of my front end and back end. While I think it would've been a smarter choice to have Swift interact with a hosted Python server for algorithmic analysis, I treated this project as a challenge to myself to only use Swift. I connected the project of firebase to store information about each user account and attach a user account to a Face ID from Azure. I used Azure for facial recognition which, in conjunction with verbal security questions, authenticated users for purchases. I connected this to Stripe to conduct purchases.

## Challenges I ran into
Swift is a challenging language to work with for networking. Since Firebase was asynchronous, and I struggled with working on asynchronous APIs, I had to design my code in such a way that I had the user details before my app queued questions about the user. I also never used the Firebase authentication rules before. While this is essential for keeping user data safe, it was difficult to learn how to grant access only to my app and not to intruders using these rules.

## Accomplishments that I'm proud of
I'm proud that I found a unique way to use facial recognition technology in a way that could make lives better. I am fascinated by biometrics, and I think it will have a groundbreaking effect in the Financial Technology space. I am also proud that I built this all in Swift, as I now feel extremely confident in my Swift skills and that I am ready to tackle any project.

## What I learned
I learned a lot about asynchronous programming and how to make my app just as functional and more efficient. I also learned about making code that was as efficient as possible; while I didn't anticipate this, my application took a lot of computational power from the onboard CPU, and I had to do my best to reduce this effect. Finally, I mastered my skills in Swift as well as design with Swift; I used various dependancies via cocoa pods to upgrade my user experience and make the app look nice. These dependancies in conjunction with transitions, modern design, and a consistent colour theme made my application appealing to the eye.

## What's next for BiPASS
This application is simply a concept. I personally think that this type of technology isn't ready to hit the market, and shouldn't be released until facial recognition and biometrics becomes more reliable for payment use and society becomes more accustomed to this type of information use. When this technology becomes more reliable, I'll revisit my code and implement more security and technology to make it ready for market release. While it would be a dream of mine to disrupt the business space forever, for now this is simply an exercise for me that built my skills and prepared me for more challenging projects in the near future.
