Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8270454D44C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Jun 2022 00:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348255AbiFOWMm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Jun 2022 18:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349879AbiFOWMl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Jun 2022 18:12:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC12E2E
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Jun 2022 15:12:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h19so13862404wrc.12
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Jun 2022 15:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0nYF2+L0+nfm2ZZrGFnn5kpR2H6SVKM0WrlyyHrypck=;
        b=IfERn+03UqWtxXLyO34clbji2GIEw/NmkaNlK0oeunYY/1Hsy4RFRtzmZRukgQ38zS
         BZJDIKoEyYef2iPVHLWo2zeziufyg23fZvcvQwstDSlaP3Co8MYRvbvCA8cN7dzV+i86
         M9xQetZI485xvvbOtVjDy+1wJG/y2zrDyysgM0Elv9145+H/1cUqnn220imqz118qZVu
         +GGQzJ2Ak9lVih6J0scW99b1gdgm0STHKRJXpOwAXryBgGma7c/m+VuTprCV/CjwXA/q
         qDPvEDudDimD3QikadNk3tJv8DuFl1zzvXPFPycPuDupe0Ih4S7u7yEFoOf/tZzq7MK0
         J8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0nYF2+L0+nfm2ZZrGFnn5kpR2H6SVKM0WrlyyHrypck=;
        b=Z+cffWpvMS/QBP5rpzs7C7aElUMrO35S0jy+vB9oatu9VZIkZ9CXczK91kHiX1HgMv
         QhmUAG6gMI8Si9fp4j+zwGyumpixMf+T0SpF/AIiH157dUJmW+ZN9S+VSciGnOfsDtmD
         NllpolydZJAIk2oQr0WX5Q1HHMR1tg6pGFBOOYUWhyKlcrtsef7DC8QV4XNQqibGXIp7
         shlZ7kwQzXyifL+9QGm3AWPaBDFxPDc3q9NiiFfsxpTuz1Cm1J+NrQPAoBllqHqn9gHf
         NumAkrDJvJtPz/3gbARmPNBfeqrClfH2laJ+RrLxeJ6Ckd9nxGux3s8Fr5rM4IZz6mA/
         DGqg==
X-Gm-Message-State: AJIora8BVpOLSf9OJ3Dv9a0hvUDS1s6yZmCyDu0FxgNIl3UfhcVX++xD
        JlbsJkQFUUoshjov5NytPgt2BvOXmS4n3qiR/rA2
X-Google-Smtp-Source: AGRyM1u/WGHw/3tv1rjJVxbCcTw2Va1S87bCBsDXwO9w9w+rsBwJm64Rn4aYl5YK1dRF5MTqCXjGUMyJeamkdiB6/+E=
X-Received: by 2002:a05:6000:230:b0:210:31ca:28b8 with SMTP id
 l16-20020a056000023000b0021031ca28b8mr1794755wrz.538.1655331152126; Wed, 15
 Jun 2022 15:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-3-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-3-git-send-email-deven.desai@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 15 Jun 2022 18:12:21 -0400
Message-ID: <CAHC9VhQum+az8SLd64rPfi_fyHGE2nePodF_pTzUtk-8y6wpSg@mail.gmail.com>
Subject: Re: [RFC PATCH v8 02/17] ipe: add policy parser
To:     Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 8, 2022 at 3:03 PM Deven Bowers
<deven.desai@linux.microsoft.com> wrote:
>
> IPE's interpretation of the what the user trusts is accomplished through
> its policy. IPE's design is to not provide support for a single trust
> provider, but to support multiple providers to enable the end-user to
> choose the best one to seek their needs.
>
> This requires the policy to be rather flexible and modular so that
> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> some other system, can plug into the policy with minimal code changes,
> and IPE can
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
>
> v3:
>   + Move policy load and activation audit event to 03/12
>   + Fix a potential panic when a policy failed to load.
>   + use pr_warn for a failure to parse instead of an
>     audit record
>   + Remove comments from headers
>   + Add lockdep assertions to ipe_update_active_policy and
>     ipe_activate_policy
>   + Fix up warnings with checkpatch --strict
>   + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>     nodes.
>   + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>   + Remove strict_parse command line parameter, as it is added
>     by the sysctl command line.
>   + Prefix extern variables with ipe_
>
> v4:
>   + Remove securityfs to reverse-dependency
>   + Add SHA1 reverse dependency.
>   + Add versioning scheme for IPE properties, and associated
>     interface to query the versioning scheme.
>   + Cause a parser to always return an error on unknown syntax.
>   + Remove strict_parse option
>   + Change active_policy interface from sysctl, to securityfs,
>     and change scheme.
>
> v5:
>   + Cause an error if a default action is not defined for each
>     operaiton.
>   + Minor function renames
>
> v6:
>   + No changes
>
> v7:
>   + Further split parser and userspace interface into two
>     separate commits, for easier review.
>
>   + Refactor policy parser to make code cleaner via introducing a
>     more modular design, for easier extension of policy, and
>     easier review.
>
> v8:
>   + remove unnecessary pr_info emission on parser loading
>
>   + add explicit newline to the pr_err emitted when a parser
>     fails to load.
> ---
>  include/asm-generic/vmlinux.lds.h    |  16 +
>  security/ipe/Makefile                |   6 +
>  security/ipe/ipe.c                   |  61 ++
>  security/ipe/ipe.h                   |   5 +
>  security/ipe/ipe_parser.h            |  59 ++
>  security/ipe/modules.c               | 109 +++
>  security/ipe/modules.h               |  17 +
>  security/ipe/modules/ipe_module.h    |  33 +
>  security/ipe/parsers.c               | 143 ++++
>  security/ipe/parsers/Makefile        |  12 +
>  security/ipe/parsers/default.c       | 106 +++
>  security/ipe/parsers/policy_header.c | 126 ++++
>  security/ipe/policy.c                | 946 +++++++++++++++++++++++++++
>  security/ipe/policy.h                |  97 +++
>  14 files changed, 1736 insertions(+)
>  create mode 100644 security/ipe/ipe_parser.h
>  create mode 100644 security/ipe/modules.c
>  create mode 100644 security/ipe/modules.h
>  create mode 100644 security/ipe/modules/ipe_module.h
>  create mode 100644 security/ipe/parsers.c
>  create mode 100644 security/ipe/parsers/Makefile
>  create mode 100644 security/ipe/parsers/default.c
>  create mode 100644 security/ipe/parsers/policy_header.c
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h

I had a few small comments while reading through this code, e.g. try
to drop the support for quoted values, but I think my big issue here
is that non-trivial string parsers in the kernel make me nervous and
with +1700 lines spread across 14 files this is definitely a
non-trivial parser.

I understand the basic 'key=value' pair format, and I think that's
okay, but I worry about the added complexity in the parser brought
about by the need to introduce an abstraction layer between the core
parser(s) and modules.  I realize flexibility is an important part of
IPE, and this relies on the ability to add support for new language
keys/modules, but I don't believe that requires the level of
indirection seen here.

I'm not asking you to make radical changes to the IPE policy language,
but I do believe spending some time to rethink how you parse the
language would be a good idea.  When in doubt keep the parser as
simple as possible, you can always add complexity and more nuance in
the future when the language requires it.  The IPE policy language
grammar is the immutable kernel/userspace API promise, not the parser
implementation.

--
paul-moore.com
