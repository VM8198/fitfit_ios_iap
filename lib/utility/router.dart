import 'package:flutter/material.dart';
import 'package:flutter_fitfit/screen/discover.dart';
import 'package:flutter_fitfit/screen/personalized_training.dart';
import 'package:flutter_fitfit/screen/preview_exercise.dart';
import 'package:flutter_fitfit/screen/profile/profile.dart';
import 'package:flutter_fitfit/screen/pt_circular_timer.dart';
import 'package:flutter_fitfit/screen/pt_workout_complete.dart';
import 'package:flutter_fitfit/screen/question/analyze.dart';
import 'package:flutter_fitfit/screen/question/complete.dart';
import 'package:flutter_fitfit/screen/home.dart';
import 'package:flutter_fitfit/screen/question.dart';
import 'package:flutter_fitfit/screen/question/update_question.dart';
import 'package:flutter_fitfit/screen/screen.dart';
import 'package:flutter_fitfit/screen/subscription/first_time_customer.dart';
import 'package:flutter_fitfit/screen/subscription/my_subscription.dart';
import 'package:flutter_fitfit/screen/subscription/returning_customer.dart';
import 'package:flutter_fitfit/screen/warmup.dart';
import 'package:flutter_fitfit/screen/workout_circular_timer.dart';
import 'package:flutter_fitfit/screen/workout_complete.dart';
import 'package:flutter_fitfit/screen/workout_detail.dart';
import 'package:flutter_fitfit/screen/workout_feedback.dart';
import 'package:flutter_fitfit/screen/workout_group.dart';
import 'package:flutter_fitfit/screen/workout_intermediate.dart';
import 'package:flutter_fitfit/screen/workout_quit_survey.dart';
import 'package:flutter_fitfit/screen/workout_ready.dart';
import 'package:flutter_fitfit/screen/weight_update.dart';
import 'package:flutter_fitfit/screen/weight_all.dart';
import 'package:flutter_fitfit/screen/workout_timer.dart';
import 'package:flutter_fitfit/screen/profile/settings.dart';
import 'package:flutter_fitfit/screen/update_password.dart';

class Router {
  static Route onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case WelcomePage.routeName:
        return _buildRoute(settings, WelcomePage());

      case LoginPage.routeName:
        return _buildRoute(settings, LoginPage());

      case VerificationCodePage.routeName:
        return _buildRoute(settings, VerificationCodePage());

      case SignUpPage.routeName:
        return _buildRoute(settings, SignUpPage());

      case QuestionPage.routeName:
        return _buildRoute(settings, QuestionPage());

      case QuestionAnalyzePage.routeName:
        return _buildRoute(settings, QuestionAnalyzePage());

      case QuestionCompletePage.routeName:
        return _buildRoute(settings, QuestionCompletePage());

      case MyProgressPage.routeName:
        return _buildRoute(settings, MyProgressPage());

      case ForgotPasswordPage.routeName:
        return _buildRoute(settings, ForgotPasswordPage());

      case UpdatePasswordPage.routeName:
        return _buildRoute(settings, UpdatePasswordPage());

      case QuestionAnalyzePage.routeName:
        return _buildRoute(settings, QuestionAnalyzePage());

      case QuestionCompletePage.routeName:
        return _buildRoute(settings, QuestionCompletePage());

      case DiscoverPage.routeName:
        return _buildRoute(settings, DiscoverPage());

      case WorkoutGroupPage.routeName:
        return _buildRoute(settings, WorkoutGroupPage());

      case WorkoutDetailPage.routeName:
        return _buildRoute(settings, WorkoutDetailPage());

      case PreviewExercisePage.routeName:
        return _buildRoute(settings, PreviewExercisePage(
          argument: settings.arguments,
        ));

      case WarmupPage.routeName:
        return _buildRoute(settings, WarmupPage());

      case WorkoutReadyPage.routeName:
        return _buildRoute(settings, WorkoutReadyPage());

      case WorkoutQuitSurveyPage.routeName:
        return _buildRoute(settings, WorkoutQuitSurveyPage());

      case WorkoutIntermediatePage.routeName:
        return _buildRoute(settings, WorkoutIntermediatePage());

      case WorkoutCircularTimerPage.routeName:
        return _buildRoute(settings, WorkoutCircularTimerPage());
        
      case WorkoutTimerPage.routeName:
        return _buildRoute(settings, WorkoutTimerPage(
          argument: settings.arguments,
        ));
        
      case PersonalizedTrainingPage.routeName:
        return _buildRoute(settings, PersonalizedTrainingPage());

      case HomePage.routeName:
        return _buildRoute(settings, HomePage());

      case ProfilePage.routeName:
        return _buildRoute(settings, ProfilePage());
      
      case WeightUpdatePage.routeName:
        return _buildRoute(settings, WeightUpdatePage());

      case WeightAllPage.routeName:
        return _buildRoute(settings, WeightAllPage());

      case WorkoutCompletePage.routeName:
        return _buildRoute(settings, WorkoutCompletePage(
          argument: settings.arguments,
        ));

      case SettingsPage.routeName:
        return _buildRoute(settings, SettingsPage());

      case PtCircularTimerPage.routeName:
        return _buildRoute(settings, PtCircularTimerPage(
          argument: settings.arguments,
        ));

      case WorkoutFeedbackPage.routeName:
        return _buildRoute(settings, WorkoutFeedbackPage());

      case PtWorkoutCompletePage.routeName:
        return _buildRoute(settings, PtWorkoutCompletePage(
          argument: settings.arguments,
        ));

      case UpdateQuestionPage.routeName:
        return _buildRoute(settings, UpdateQuestionPage(
          argument: settings.arguments,
        ));

      case FirstTimeCustomerSubscriptionPage.routeName:
        return _buildRoute(settings, FirstTimeCustomerSubscriptionPage());

      case ReturningCustomerSubscriptionPage.routeName:
        return _buildRoute(settings, ReturningCustomerSubscriptionPage());

      case MySubscriptionPage.routeName:
        return _buildRoute(settings, MySubscriptionPage());

      default:
        return null;
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget screen) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (_) => screen,
    );
  }
}