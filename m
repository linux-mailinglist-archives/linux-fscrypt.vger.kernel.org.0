Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6F26E5181
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Apr 2023 22:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDQUQp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Apr 2023 16:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDQUQn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Apr 2023 16:16:43 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550C246BC
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Apr 2023 13:16:41 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-54f21cdfadbso380046197b3.7
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Apr 2023 13:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681762600; x=1684354600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkFM4OddDI3MzXQTdAgqfF3VU3F/+LgzOjoA+7s8XA4=;
        b=Ml35Br1S4fB3lQjg+85g3UBuNpD2qRSHHrPy7eSM2cIKJ0UHgLPilBvXvoOd26NpVQ
         XScr4M6uxDpgNOv8wz3lwCYE24jCZFRGgOvMfIhHkdttvMie4TqlWXyoZi7H5u5YSb/G
         jW/p817xKSmzxkgQXaPUdAbZpNp4DpLIB3lm+1FhoqzLTLUUqTavEQlTtnPv9HlQ8HMQ
         e119/w9x96Z3IkM9ZXV6zNWtzvuCmN5sJD3GY4c5m6weNq50I9GDsXzCjT4/5MAIWwbl
         /EqEfWvaLjxUeqvn7BVtzYa97LE8hT7Mu7aE7S+4t84d0NzWjqskd+G/HvvL/AJivftr
         B7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681762600; x=1684354600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkFM4OddDI3MzXQTdAgqfF3VU3F/+LgzOjoA+7s8XA4=;
        b=C0bPLIuqPrcF29y9A9jlZTxjzkIDTNyluO3okHpxI0J6q/Iwt2gS12EW/vpnfoJeDc
         ICR+O1RFU+dQSkzmRCtaf3EobyX6kw4m84HTLBVo9IhaAFZY04CTn0CXZaHrowbLBYVB
         jUvbjC4tm9XjbDLaOcEuml0VzoHeALvi+OiqqwyqQbVcu+/kV34FmaHUR3tfJO5GpCKO
         O+WFdHqFjp9FkgWWaGroMzLsA8tTipAANvM/7qEC+gw6sUY2rLFnh/VYJdTxpzj7AKBJ
         Mmt7sihUNV8TwgmEM7gq5wRnQNtV9rMo3EbapLm913ezn5B3kH2UWce+kZvPvO23O/fx
         WC1A==
X-Gm-Message-State: AAQBX9dTx7EUySZ8NfCYb8MZIrJNCp3LW7QYmePLw4v/YYeLlERr27yV
        uq6ERMMeEd7UxW2L+yj3bKrDAqCU4jId9iqQGelP
X-Google-Smtp-Source: AKy350ZxQlOfbob70cyzh//3Qo4gX/RJVSVzb07xLMzIeYlrCU36AjFdx5P2s2Fo1lBjmj4URw4Qp0a1MdAC8VUyDYc=
X-Received: by 2002:a81:4524:0:b0:54f:aa4b:100c with SMTP id
 s36-20020a814524000000b0054faa4b100cmr9804160ywa.8.1681762600389; Mon, 17 Apr
 2023 13:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com> <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 17 Apr 2023 16:16:29 -0400
Message-ID: <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
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

On Mon, Apr 17, 2023 at 2:06=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On Thu, Apr 13, 2023 at 02:45:07PM -0400, Paul Moore wrote:
> > On Wed, Apr 12, 2023 at 7:36???PM Fan Wu <wufan@linux.microsoft.com> wr=
ote:
> > > On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> > > > On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com=
> wrote:
> > > > > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > > > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft=
.com> wrote:
> >
> > ...
> >
> > > > I guess this does make me wonder about keeping a non-active policy
> > > > loaded in the kernel, what purpose does that serve?
> > > >
> > >
> > > The non-active policy doesn't serve anything unless it is activated. =
User can
> > > even delete a policy if that is no longer needed. Non-active is just =
the default
> > > state when a new policy is loaded.
> > >
> > > If IPE supports namespace, there is another use case where different =
containers
> > > can select different policies as the active policy from among multipl=
e loaded
> > > policies. Deven has presented a demo of this during LSS 2021. But thi=
s goes
> > > beyond the scope of this version.
> >
> > Do you plan to add namespace support at some point in the
> > not-too-distant future?  If so, I'm okay with keeping support for
> > multiple policies, but if you think you're only going to support one
> > active policy at a time, it might be better to remove support for
> > multiple (inactive) policies.
> >
> > --
> > paul-moore.com
>
> Another benefit of having multiple policies is that it provides isolation
> between different policies. For instance, if we have two policies named
> "policy_a" and "policy_b," we can ensure that only team a can update "pol=
icy_a,"
> and only team b can update "policy_b." This way, both teams can update
> their policy without affecting others. However, if there is only one poli=
cy
> in the system, both teams will have to operate on the same policy, making=
 it
> less manageable.

That only really matters if both policies are active at the same time;
if only one policy can be active at one point in time the only
permission that matters is the one who can load/activate a policy.

Allowing for multiple policies complicates the code.  If there is
another feature that requires multiple policies, e.g. IPE namespaces,
then that is okay.  However, if there is no feature which requires
multiple active policies, supporting multiple loaded policies only
increases the risk of an exploitable bug in the IPE code.

> Besides, removing multiple (inactive) policies support will
> render the policy_name field meaningless, and we should only audit the po=
licy
> hash. I am fine if we decide to go for the single policy option.

Once again, I think it comes back to: do you still want to support IPE
namespaces at some point in the future, and if so, when do you expect
to work on that?

--=20
paul-moore.com
