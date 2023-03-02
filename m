Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B626A8916
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCBTI0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCBTIT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:08:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EF44ECA
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:08:15 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so3792703pjb.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677784095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vdu6kOAJ1Ups+aUuKMhdxW9mbKAGnc9mpfEPZtQ5oYc=;
        b=QCBxot5UEe92USFtl63SUB/c1YdLVxScPQJ1P4QKkUVllAOjkExvExOlk22Y+cAPLp
         7weEoPvxZ0D+WDb8BBKIVp9dG4Qk6OQkdh8kKA3dGVcxvksE7MJCCR2RE4qhTXvYfGvU
         jgj/tDTwkb4LQQic+6FFlgFTo6sCZEIGs5slvhlNdP2IW3PkjwzxqzAKtaNvhqrh1ARk
         Fk945S48pTjqSBexPAR6DDMtcXU3MwN4FBw5DjJSxESA4tj2RXONXJlXtInGbuPs/1lK
         6Em3Vjg2pr05lfKVnhLnuoPez7jPU4XUgCaO4BKItyg6p/BwZcZW+iA8dgGN98E+y8bW
         DE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677784095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vdu6kOAJ1Ups+aUuKMhdxW9mbKAGnc9mpfEPZtQ5oYc=;
        b=e/HssTLa99Wz0im9r0OvrOY7UsjwiW+dJ89G51XZMG7vwVujLBhlCi6lE8gHErUOXj
         haOLJDu2r5ZikUymtmqgxBVEjvoz3MAjxh44/WzU9Ohiw6ylGCEvz4Rm5HwlQtmVTQ4a
         mQmLWoIShLkLLAcfqb7BgOecTOQ+uFdbow1TvhHXqhWKJQ4c7G3R1Dp9F7iE0E1h+Td1
         Ij1NeFNwKrEWTgLAIaY8I+BRhzaSy9tpg557DdxlUQxGN4ETx05qfrvaumfWttxM797j
         kNxZd6hhXoHsUPUl7ooL6/eDAfQuyPg9rTtRUN34iJmq5I3kntfX6q2mPjm/kdzZJMu4
         pGXg==
X-Gm-Message-State: AO0yUKXWM2GWW6rlSsa9E9kSrjY3uRPO49cE5xD4HLGkZ6sjPiZMcGH0
        i8pOVh5yJEhql5LYwKmZjlHF6aWcZ5vDLVHUxytC
X-Google-Smtp-Source: AK7set9s3MxX+z1dx88uX1Fs1h5mTCDHnH5bToYcnqr8ZticQMwTWq2upjnKLw2DFG5CIW3NG3MUdlWUtltns+RDwxc=
X-Received: by 2002:a17:903:1d1:b0:19c:cb32:bfef with SMTP id
 e17-20020a17090301d100b0019ccb32bfefmr4510758plh.3.1677784095231; Thu, 02 Mar
 2023 11:08:15 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-12-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-12-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:08:04 -0500
Message-ID: <CAHC9VhRdm_xpXNQvSVO2hkx2js=_zzo2DiQ6PvEjAEet4OjxNw@mail.gmail.com>
Subject: Re: [RFC PATCH v9 11/16] ipe: add support for dm-verity as a trust provider
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 30, 2023 at 5:58=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
>
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> Allows author of IPE policy to indicate trust for a singular dm-verity
> volume, identified by roothash, through "dmverity_roothash" and all
> signed dm-verity volumes, through "dmverity_signature".
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

...

> ---
>  security/ipe/Kconfig         |  20 +++++
>  security/ipe/Makefile        |   2 +
>  security/ipe/audit.c         |  24 ++++++
>  security/ipe/digest.c        | 144 +++++++++++++++++++++++++++++++++++
>  security/ipe/digest.h        |  26 +++++++
>  security/ipe/eval.c          | 103 +++++++++++++++++++++++++
>  security/ipe/eval.h          |  13 ++++
>  security/ipe/hooks.c         |  51 +++++++++++++
>  security/ipe/hooks.h         |   8 ++
>  security/ipe/ipe.c           |  15 ++++
>  security/ipe/ipe.h           |   4 +
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |  16 ++++
>  13 files changed, 429 insertions(+)
>  create mode 100644 security/ipe/digest.c
>  create mode 100644 security/ipe/digest.h
>
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index ac4d558e69d5..16e835ce61b0 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -15,3 +15,23 @@ menuconfig SECURITY_IPE
>           admins to reconfigure trust requirements on the fly.
>
>           If unsure, answer N.
> +
> +if SECURITY_IPE
> +menu "IPE Trust Providers"
> +
> +config IPE_PROP_DM_VERITY
> +       bool "Enable support for dm-verity volumes"
> +       depends on DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
> +       default Y
> +       help
> +         This option enables the properties 'dmverity_signature' and
> +         'dmverity_roothash' in IPE policy. These properties evaluates
> +         to TRUE when a file is evaluated against a dm-verity volume
> +         that was mounted with a signed root-hash or the volume's
> +         root hash matches the supplied value in the policy.
> +
> +         If unsure, answer Y.

If you had both IPE and dm-verity enabled in your kernel build, is
there ever a case where you wouldn't want IPE_PROP_DM_VERITY?  I
suspect you can just have IPE and dm-verity select IPE_PROP_DM_VERITY
and not bother the user/admin with the additional Kconfig knob.

> +endmenu
> +
> +endif

--
paul-moore.com
