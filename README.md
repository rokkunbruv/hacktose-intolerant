<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![project_license][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url] -->

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/rokkunbruv/hacktose-intolerant">
    <img src="assets/tultul-logo.svg" alt="Logo" width="80" height="80">
  </a>

  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMXoxMDV5Z2s0bXp4NjQ1cG92eW5kaWl4eWowbW9ncjU1eGF0N2IwdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xFxJSMW5Z3mLiRvtxP/giphy.gif" alt="output routes gif" width="80" height="80">

  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZXJjcW05bzJ4bjZsbnc2bWh1cDFpMTZjcmF2anEwN2Y3OTdxOTUwZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/pGNrBuYBLmdfe0YzjL/giphy.gif" alt="ai gif" width="80" height="80">

  <img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExZWZyZjZtaWZybGFzY29zYmI0a3prMjltMHRnYzFvYzB3cTk5cW02dSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/CO60g9CHMdqYLRXjKE/giphy.gif" alt="tara gif" width="80" height="80">

  
	

<h3 align="center">Tultul</h3>

  <p align="center">
    <i><strong>Wala ka katultul? Gamita ang Tultul!</strong></i>
   <!-- <a href="#usage">View Demo</a> -->
    <br />
    <br />
    <p><i>Note: README template borrowed <a href="https://github.com/othneildrew/Best-README-Template">here.</a></i></p>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-tultul">About Tultul</a>
      <ul>
        <li><a href="#key-features">Key Features</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#installation">Installation</a></li>
    <li>
      <a href="#manually-run-the-app">Manually Run the App</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#app-installation">App Installation</a></li>
        <li><a href="#server-setup">Server Setup</a></li>
      </ul>
    </li>
    <li><a href="#about-the-team">About the Team</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About Tultul

<img src="assets/tultul-app-name.svg" alt="Tultul" />

Tultul is a public transportation app that assists users in commuting via jeepneys in Cebu. Tultul is designed for residents who regularly commute or are new to commuting through jeepneys in Cebu.



Tultul is Team Hacktose Intolerant's submission to the UP Komsai Week 2025
Hackathon Event managed by UPCSG.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Key Features

* ***Search Available Routes***:
  * **Suggested Routes**: Tultul suggests available routes given an origin and destination locations.
  * **Route Details**: Users can view the total distance covered, total fare, and estimated time of arrival for each suggested route.
  * **Filter by Fare**: Suggested routes are filtered by the lowest fare, ensuring that users can easily see the cheapest route option.
  * **View Fare Changes**: Fares are automatically calculated based on the jeepney type *(traditional or modern)* and the passenger type *(regular, student, senior citizen, PWD)*.
  * **Real-Time Position Tracking**: Users can set their current position as their origin/destination location.
* ***Jeepney Tracker***
  * **Real-Time Tracking**: Tultul tracks the current positions of the jeepneys in real-time.
  * **Map Tracking**: Users can view the current positions of the jeepneys on the map view.
  * **Tracking for each Jeepney Code**: Jeepneys of a given jeepney code are displayed to the user.
* ***Route Follower***
  * **Step-by-Step Details**: Users can view the step-by-step instructions on navigating along a given route.
  * **Progress Tracking**: Users can track their progress in following through the route.
  * **Map Visualization**: Users can view which path they should take on the map view.
* ***View Jeepney Routes***
  * **Display Route Coverage**: Users can view the whole route coverage of a given jeepney code on the map view.
  * **Select Jeepney Code**: Tultul provides a set of jeepney codes whose route coverage can be displayed to the users.
* ***Voice Assistant***
  * **AI-Powered Route Recommendations**: Tultul's voice assistant can suggest a route given specified landmarks.
  * **Accessibility**: Tultul's voice assistant can assist persons with disabilities in suggesting a route.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

<div align="center">
	<code><img width="100" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/flutter.png" alt="Flutter" title="Flutter" />Flutter</code>
	<code><img width="100" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/django.png" alt="Django" title="Django" />Django</code>
	<code><img width="100" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/aws.png" alt="AWS" title="AWS" />AWS</code>
</div>
<div align="center">
  <code><img width="100" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/postgresql.png" alt="PostgreSQL" title="PostgreSQL" />PostgreSQL</code>
  <code><img width="85" src="https://upload.wikimedia.org/wikipedia/commons/a/aa/Google_Maps_icon_%282020%29.svg" alt="Google Maps Platform" title="Google Maps Platform" />Google Maps Platform</code>
  <code><img width="100" src="https://icon.icepanel.io/Technology/svg/FastAPI.svg" alt="FastAPI" title="FastAPI" />FastAPI</code>
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- DOWNLOADS -->
## Installation

You can download the versions of the app [here]().

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- INSTALLATION GUIDE -->
## Manually Run the App

The following steps below walk you through the process of running the app locally on your computer:

### Prerequisites

This assumes that you already have installed and configured in your system **Flutter** for the front-end
and **Python** for the back-end (it is preferable that you have the latest versions of both). This also assumes that you already have configured your
access to **Google Developer Console** since this setup requires you to use your own Google Maps API key.

If you want to run the server locally, this assumes that you already have configured your own PostgresSQL database.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### App Installation

1. Clone the repository

```bash
git clone https://github.com/rokkunbruv/hacktose-intolerant.git
```

2. Set current working directory to the `frontend` directory

```bash
cd frontend
```

3. Install necessary Flutter packages 

```bash
flutter pub get
```

4. Configure app's custom splash screen *(optional; you may want to do this if you want to display the custom splash screen on your end)*

```bash
dart run flutter_native_splash:create
```

5. Configure app's custom launcher icon *(optional; you may want to do this if you want to display the custom splash screen on your end)*

```bash
dart run flutter_launcher_icons:generate
```

6. Create a `.env` file in the `frontend` directory and store your Google Maps API key there. You might want to refer to `env.example` to see how you can add your API key there.

7. Run the app through the terminal

```bash
flutter run
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Server Setup

If you choose to run the server-side locally, you might want to follow these steps:

1. Ensure that the repository has been cloned to your system. If not, run

```bash
git clone https://github.com/rokkunbruv/hacktose-intolerant.git
```

2. Set current working directory to the `commuteProj` directory in `backend`

```bash
cd backend/commuteProj
```

3. Install necessary dependencies

```bash
pip install -r ../requirements.txt
```

4. Migrate database changes

```bash
python manage.py migrate
```

5. Create a `.env` file in the `commuteProj` directory and store your Google Maps API key and your PostgresSQL database credentials there. You might want to refer to `env.example` to see how you can add your API key there.

6. Run the server

```bash
python manage.py runserver
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## About the Team

<a href="https://github.com/rokkunbruv/hacktose-intolerant/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=rokkunbruv/hacktose-intolerant" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
<!-- ## License

Distributed under the project_license. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- CONTACT -->
<!-- ## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email@email_client.com

Project Link: [https://github.com/github_username/repo_name](https://github.com/github_username/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* This README template is borrowed from the [Best-README-Template](https://github.com/othneildrew/Best-README-Template/blob/main/README.md) Github repository
* The tech stack icons were generated using [Profile Technology Icons](https://marwin1991.github.io/profile-technology-icons/)
* The jeepney route polylines were obtained from [Cebu Jeepneys Route Map](https://cebujeepneys.weebly.com/jeepney-routes.html)
* The custom map style used on the map view is [Interface map by samisel on Snazzy Maps](https://snazzymaps.com/style/1243/xxxxxxxxxxx).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
<!--
[contributors-shield]: https://img.shields.io/github/contributors/github_username/repo_name.svg?style=for-the-badge
[contributors-url]: https://github.com/github_username/repo_name/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/github_username/repo_name.svg?style=for-the-badge
[forks-url]: https://github.com/github_username/repo_name/network/members
[stars-shield]: https://img.shields.io/github/stars/github_username/repo_name.svg?style=for-the-badge
[stars-url]: https://github.com/github_username/repo_name/stargazers
[issues-shield]: https://img.shields.io/github/issues/github_username/repo_name.svg?style=for-the-badge
[issues-url]: https://github.com/github_username/repo_name/issues
[license-shield]: https://img.shields.io/github/license/github_username/repo_name.svg?style=for-the-badge
[license-url]: https://github.com/github_username/repo_name/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png
-->
