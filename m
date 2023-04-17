Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EA66E53C4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Apr 2023 23:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjDQVSb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Apr 2023 17:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjDQVSa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Apr 2023 17:18:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57BF4358E;
        Mon, 17 Apr 2023 14:18:27 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id C4C642121EDA; Mon, 17 Apr 2023 14:18:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4C642121EDA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681766306;
        bh=adEiw2P3m6cnH/sSQWbv/VRy1L8dfjJvgoBhVAuKoCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pDcqc7nOAlMWgb5iUoPmpZK+iYwHaGDUUCZGq03wT0breKlSPheAu0Q19ITc5ZMjt
         KmIEG6hyvi082JVHziyG6tMTac9Cc5cs6DsHJ/4WGETlBIH8Z8GoJfJYGo2Yf6UKFa
         8mX5R5MOgiWTO1WtOywxrA0DdWvos8adHeodyOA4=
Date:   Mon, 17 Apr 2023 14:18:26 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 05/16] ipe: add userspace interface
Message-ID: <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
 <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 17, 2023 at 04:16:29PM -0400, Paul Moore wrote:
> On Mon, Apr 17, 2023 at 2:06???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Thu, Apr 13, 2023 at 02:45:07PM -0400, Paul Moore wrote:
> > > On Wed, Apr 12, 2023 at 7:36???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > > On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> > > > > On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > > > > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > > > > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > >
> > > ...
> > >
> > > > > I guess this does make me wonder about keeping a non-active policy
> > > > > loaded in the kernel, what purpose does that serve?
> > > > >
> > > >
> > > > The non-active policy doesn't serve anything unless it is activated. User can
> > > > even delete a policy if that is no longer needed. Non-active is just the default
> > > > state when a new policy is loaded.
> > > >
> > > > If IPE supports namespace, there is another use case where different containers
> > > > can select different policies as the active policy from among multiple loaded
> > > > policies. Deven has presented a demo of this during LSS 2021. But this goes
> > > > beyond the scope of this version.
> > >
> > > Do you plan to add namespace support at some point in the
> > > not-too-distant future?  If so, I'm okay with keeping support for
> > > multiple policies, but if you think you're only going to support one
> > > active policy at a time, it might be better to remove support for
> > > multiple (inactive) policies.
> > >
> > > --
> > > paul-moore.com
> >
> > Another benefit of having multiple policies is that it provides isolation
> > between different policies. For instance, if we have two policies named
> > "policy_a" and "policy_b," we can ensure that only team a can update "policy_a,"
> > and only team b can update "policy_b." This way, both teams can update
> > their policy without affecting others. However, if there is only one policy
> > in the system, both teams will have to operate on the same policy, making it
> > less manageable.
> 
> That only really matters if both policies are active at the same time;
> if only one policy can be active at one point in time the only
> permission that matters is the one who can load/activate a policy.
> 
> Allowing for multiple policies complicates the code.  If there is
> another feature that requires multiple policies, e.g. IPE namespaces,
> then that is okay.  However, if there is no feature which requires
> multiple active policies, supporting multiple loaded policies only
> increases the risk of an exploitable bug in the IPE code.
> 
> > Besides, removing multiple (inactive) policies support will
> > render the policy_name field meaningless, and we should only audit the policy
> > hash. I am fine if we decide to go for the single policy option.
> 
> Once again, I think it comes back to: do you still want to support IPE
> namespaces at some point in the future, and if so, when do you expect
> to work on that?
> 

Yes, absolutely! We definitely have plans to support namespaces in the future.
However, it's worth mentioning that there are other tasks that we may need
to prioritize due to their relatively lower complexity. For example, before
we can fully implement namespaces, we need to address some other important
aspects of the system, such as adding a policy language for integrity
enforcement on configuration files and defining trusted certificates
that can sign the root hash. Therefore, the timeline for implementing
namespaces will depend on the completion time of these tasks.

I understand your concerns, and we can proceed with a single policy design
for the initial version.

-Fan
