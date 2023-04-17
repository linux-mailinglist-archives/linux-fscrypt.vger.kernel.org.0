Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4556E53E1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Apr 2023 23:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjDQVb1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Apr 2023 17:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjDQVb0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Apr 2023 17:31:26 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A24C10
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Apr 2023 14:31:23 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54fa9da5e5bso233367397b3.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Apr 2023 14:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681767083; x=1684359083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCzVu2UsKp7hdLDjLx5y43eqwBluLCZhJw8zkmfWK7s=;
        b=L4lIgMDUo+CoVwZROqgkHM1P5l8PMDt1tMF+3n6mYb/oTyl6jZZARiOyi4mY749zTf
         kd6MKQWITu/+gFbXbDd8PRN889Ab1UneKVGjM8dJfGHZk1x69itMrG6mVAMXx6c94Kgj
         wsnxittzLcJmNlQ2TmgAffk7LZPA0GjY7q3YVrjMNaQxDody759vfh8QxNsbIEZIbNpi
         YEiGC7lB/ogD9pMXaYUg7qcmHjeO7XkF2svcHQ6pd/dMN/CipBYMhe50S/ctKhKU/5Xb
         VduqXgJXIwtVunLI04d/oZ9995Fp6s9L0vc6khDXs8odobPBxwM6nmpDBHJfyzOBpVBf
         lSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767083; x=1684359083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCzVu2UsKp7hdLDjLx5y43eqwBluLCZhJw8zkmfWK7s=;
        b=ffY6ZoxgkceOMF5OBVqZP2ZARGNsUKr/yYWRwAS1H4uEzchePBitnFv/V9de6WRTHB
         JS+7CPOq5vHiF3TgeFYynykYcr3RXb4XH50XWYMzLnwCTELk+LdfQlr5MDZlVxDuVC8Q
         70447u4+E0Fxy3fDEfoZedx/IMxWDmqbsf9Ly7TRUewaht3AjWLPQ+ufx+Qw+OjyxT6p
         /H5xfeTRSQOYc+EwDSwjRDb00/F2XlbJzADj0Vf/WCWDFondzuX4MLHMMw4dNL3K4uNF
         nIYdMS8HJyKiKQjoUxJ7Mbt+PduYoX2R2CuWjxE5QZvfawXa8ZeKF3NqSTcyFvnuJOdm
         zqGg==
X-Gm-Message-State: AAQBX9dZeq1UQi+0BVbyf+6m6dj8zwLnluv5KBtGErWOx4uSKx3ykplk
        qz2gZcKi/dtf/UUDP2ipmURIDgyzCTtGjIcWY2G5
X-Google-Smtp-Source: AKy350bgu9ZFLZmYkOlWaVpVvG9J/JdkBbU14XNGAtkoY2ENWGlUCNYD5NN6A3BCb0Ne4rd9gsfKQgsCVLB08+3wRKo=
X-Received: by 2002:a81:c649:0:b0:54f:2b65:a865 with SMTP id
 q9-20020a81c649000000b0054f2b65a865mr10208390ywj.8.1681767082657; Mon, 17 Apr
 2023 14:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
 <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com> <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 17 Apr 2023 17:31:11 -0400
Message-ID: <CAHC9VhT9uTYrtEsXUvj5qaTpNL2ix762dE5AzUaSqzas8-frXA@mail.gmail.com>
Subject: Re: [RFC PATCH v9 05/16] ipe: add userspace interface
To:     Fan Wu <wufan@linux.microsoft.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 17, 2023 at 5:18=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On Mon, Apr 17, 2023 at 04:16:29PM -0400, Paul Moore wrote:
> > On Mon, Apr 17, 2023 at 2:06???PM Fan Wu <wufan@linux.microsoft.com> wr=
ote:
> > > On Thu, Apr 13, 2023 at 02:45:07PM -0400, Paul Moore wrote:
> > > > On Wed, Apr 12, 2023 at 7:36???PM Fan Wu <wufan@linux.microsoft.com=
> wrote:
> > > > > On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> > > > > > On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft=
.com> wrote:
> > > > > > > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > > > > > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.micro=
soft.com> wrote:
> > > >
> > > > ...
> > > >
> > > > > > I guess this does make me wonder about keeping a non-active pol=
icy
> > > > > > loaded in the kernel, what purpose does that serve?
> > > > > >
> > > > >
> > > > > The non-active policy doesn't serve anything unless it is activat=
ed. User can
> > > > > even delete a policy if that is no longer needed. Non-active is j=
ust the default
> > > > > state when a new policy is loaded.
> > > > >
> > > > > If IPE supports namespace, there is another use case where differ=
ent containers
> > > > > can select different policies as the active policy from among mul=
tiple loaded
> > > > > policies. Deven has presented a demo of this during LSS 2021. But=
 this goes
> > > > > beyond the scope of this version.
> > > >
> > > > Do you plan to add namespace support at some point in the
> > > > not-too-distant future?  If so, I'm okay with keeping support for
> > > > multiple policies, but if you think you're only going to support on=
e
> > > > active policy at a time, it might be better to remove support for
> > > > multiple (inactive) policies.
> > > >
> > > > --
> > > > paul-moore.com
> > >
> > > Another benefit of having multiple policies is that it provides isola=
tion
> > > between different policies. For instance, if we have two policies nam=
ed
> > > "policy_a" and "policy_b," we can ensure that only team a can update =
"policy_a,"
> > > and only team b can update "policy_b." This way, both teams can updat=
e
> > > their policy without affecting others. However, if there is only one =
policy
> > > in the system, both teams will have to operate on the same policy, ma=
king it
> > > less manageable.
> >
> > That only really matters if both policies are active at the same time;
> > if only one policy can be active at one point in time the only
> > permission that matters is the one who can load/activate a policy.
> >
> > Allowing for multiple policies complicates the code.  If there is
> > another feature that requires multiple policies, e.g. IPE namespaces,
> > then that is okay.  However, if there is no feature which requires
> > multiple active policies, supporting multiple loaded policies only
> > increases the risk of an exploitable bug in the IPE code.
> >
> > > Besides, removing multiple (inactive) policies support will
> > > render the policy_name field meaningless, and we should only audit th=
e policy
> > > hash. I am fine if we decide to go for the single policy option.
> >
> > Once again, I think it comes back to: do you still want to support IPE
> > namespaces at some point in the future, and if so, when do you expect
> > to work on that?
>
> Yes, absolutely! We definitely have plans to support namespaces in the fu=
ture.
> However, it's worth mentioning that there are other tasks that we may nee=
d
> to prioritize due to their relatively lower complexity. For example, befo=
re
> we can fully implement namespaces, we need to address some other importan=
t
> aspects of the system, such as adding a policy language for integrity
> enforcement on configuration files and defining trusted certificates
> that can sign the root hash. Therefore, the timeline for implementing
> namespaces will depend on the completion time of these tasks.
>
> I understand your concerns, and we can proceed with a single policy desig=
n
> for the initial version.

I think it's okay to stick with the multi-policy code for the initial
submission, you've got the code now, and it's tested.  I just wanted
to make sure there were plans to make use of it at some point, if not
we might as well drop it now.  However, it sounds like you've got a
plan to utilize the multi-policy support so that's fine with me.

--=20
paul-moore.com
