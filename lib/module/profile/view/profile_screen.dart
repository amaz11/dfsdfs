import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_assets.dart';
// import 'package:trealapp/core/utils/dimensions.dart';
// import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/profile/controller/profile_controller.dart';
import 'package:trealapp/module/profile/model/profile_model.dart';
import 'package:trealapp/module/profile/view/widget/profile_menu_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyles.title16.copyWith(color: grayColor)),
        shadowColor: Colors.black26,
        // elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu), // You can change this to any other icon
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Obx(() {
        final profileData = controller.profile.value.data;
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.isLoading.value == false) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchProfile,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Your widgets here
                              profileView(profileData!, context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text("No profile data available."));
        }
      }),
    );
  }

  Widget profileView(Data profile, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            profileImage(profile.profileImg),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * .5,
                  child: Text(
                    "${profile.firstName} ${profile.lastName}",
                    style: TextStyles.title22,
                  ),
                ),
                Text(
                  profile.employeeDesignationName ?? 'No Designation',
                  style: TextStyles.regular14
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: lightGrayColor2.withOpacity(0.2),
          ),
          child: TabBar(
              controller: controller.tabController,
              splashBorderRadius: BorderRadius.circular(50),
              indicatorPadding:
                  const EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: whiteColor,
              ),
              dividerColor: Colors.transparent,
              labelColor: grayColor,
              tabs: const [
                Tab(
                  child: Text("Personal Info"),
                ),
                Tab(child: Text("Office Info")),
              ]),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height * .5,
            child: TabBarView(controller: controller.tabController, children: [
              buildPersonalInfo(profile),
              buildOfficeInfo(profile)
            ]),
          ),
        ),
      ],
    );
  }

  Widget profileImage(String? image) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: lightGrayColor2),
          borderRadius: BorderRadius.circular(100),
        ),
        width: 80,
        height: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child:
              image == "null" ? Image.asset(profileImg) : Image.network(image!),
        ),
      ),
    );
  }

  Widget buildPersonalInfo(Data profile) {
    return Column(
      children: [
        ProfileMenuWidget(
          title: "Phone",
          value: profile.phoneNo ?? 'No Phone Number',
          icon: Icons.phone_outlined,
        ),
        ProfileMenuWidget(
          title: "Present Address",
          value: profile.presentAddress ?? 'No Address',
          icon: Icons.place_outlined,
        ),
        ProfileMenuWidget(
          title: "Permanent Address",
          value: profile.permanentAddress ?? 'No Address',
          icon: Icons.home_outlined,
        ),
      ],
    );
  }

  Widget buildOfficeInfo(Data profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileMenuWidget(
            title: "Email",
            value: profile.email ?? 'No Email',
            icon: Icons.email_outlined,
          ),
          ProfileMenuWidget(
            title: "Username",
            value: profile.username ?? 'No Username',
            icon: Icons.person_outline_outlined,
          ),
          ProfileMenuWidget(
            title: "Company",
            value: profile.companyName ?? 'No Company',
            icon: Icons.business_outlined,
          ),
          ProfileMenuWidget(
            title: "Designation",
            value: profile.employeeDesignationName ?? 'No Designation',
            icon: Icons.badge_outlined,
          ),
          ProfileMenuWidget(
            title: "Join date",
            value: profile.joiningDate ?? 'No Date Add',
            icon: Icons.date_range_outlined,
          )
        ],
      ),
    );
  }
}
