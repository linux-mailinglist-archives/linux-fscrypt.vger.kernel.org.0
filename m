Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA6C6A88CA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjCBTBF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCBTBD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:01:03 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2763C193F3
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:01:01 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z10so62659pgr.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677783660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbKqTB1BWmST+UKS3o/pcnOIniBYA6/WBLEtc9haQn4=;
        b=f6CB0s+KV2OW0hRLDgrai9rYXWAdgEzOd1HKjzgncsSTbWytg8B0shiJ79cVHIi1vO
         NfrTj+lMOtmVES/SN5tUizQ34VKdLqix9CWELeH+KrTcEymXdzPIEexDiBaqMU7ww0GK
         sGzZ7mXcF5H5dCoMBQm44MSvQYc8W4Wy/Uzn9pe7oVpFrQ270ldOFxuD0OsCggJ0HBqc
         bMLhtiOMAAtD+EpZC0R6O8ttn+ahurnj9OFXO0sVBcvxvdJHFYhROyspmOHRH+P1DqMB
         PN1J3UoPaWpHoy6A49mEBkZV5JgSIJF6mSkQjZ9rqaOJmSJo8zGtxSMzri02uyU/YtOE
         ipwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677783660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbKqTB1BWmST+UKS3o/pcnOIniBYA6/WBLEtc9haQn4=;
        b=DbpIaWARRP8VMT7obTEUqsryf3Ekxfd0fZAShbe8/bPJdDDguNKMjVDYncjsb0JobC
         3KchCs136XR5tAYkeCRMkNKeRiMkEMiZOMRr8NPau0nSBa+2JJlA7a7S4G/XRAMfKCaw
         nGiie2XRTjN/gavYcha2gqSwVneGqA0Od6Lwrj1BaeqyDn7rEr8tnhmGd+JJfTw3lZwn
         DUt4ZHRWkRQc4M7mfcoFcP4q2cRKSWgMyXVlb9cHv2LEWy6ZLjBI87Ewsj+XfU/nhMyu
         4a006XA3Mf1RFrMTzBEGapJeF/wVN7zGAt9h1OEXFlg0/rUW7AdqoamSfc9N4FB4bVpC
         /x2w==
X-Gm-Message-State: AO0yUKWrDCxd/t4Go6iiWAuZTDjOS0ot5dDO7ntcNFWFsUT8k7TRNmqG
        wnTYpeyjFbgoK9zZ4LallqQ+t7TjAomGTAjv02ee
X-Google-Smtp-Source: AK7set/JqphcjYj9seuvS6xKNvURMu+S3V/LEScKzhxHP7SqFb0AhXhOojS1vVfFsCMHm+0xdSDtgJ0BLFb+6ahFIIw=
X-Received: by 2002:a63:2953:0:b0:503:91ff:8dd8 with SMTP id
 bu19-20020a632953000000b0050391ff8dd8mr2858904pgb.4.1677783659129; Thu, 02
 Mar 2023 11:00:59 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-2-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:00:48 -0500
Message-ID: <CAHC9VhTtXC=HMUF8uak-29E__xLN2Kh_znn0xdRbm-GkgqBNiA@mail.gmail.com>
Subject: Re: [RFC PATCH v9 01/16] security: add ipe lsm
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
> Integrity Policy Enforcement (IPE) is an LSM that provides an
> complimentary approach to Mandatory Access Control than existing LSMs
> today.
>
> Existing LSMs have centered around the concept of access to a resource
> should be controlled by the current user's credentials. IPE's approach,
> is that access to a resource should be controlled by the system's trust
> of a current resource.
>
> The basis of this approach is defining a global policy to specify which
> resource can be trusted.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

...

> ---
>  MAINTAINERS           |  5 +++++
>  security/Kconfig      | 11 ++++++-----
>  security/Makefile     |  1 +
>  security/ipe/Kconfig  | 17 +++++++++++++++++
>  security/ipe/Makefile | 10 ++++++++++
>  security/ipe/ipe.c    | 40 ++++++++++++++++++++++++++++++++++++++++
>  security/ipe/ipe.h    | 13 +++++++++++++
>  7 files changed, 92 insertions(+), 5 deletions(-)
>  create mode 100644 security/ipe/Kconfig
>  create mode 100644 security/ipe/Makefile
>  create mode 100644 security/ipe/ipe.c
>  create mode 100644 security/ipe/ipe.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8a5c25c20d00..5e27e84763cc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10273,6 +10273,11 @@ T:     git git://git.kernel.org/pub/scm/linux/ke=
rnel/git/zohar/linux-integrity.git
>  F:     security/integrity/ima/
>  F:     security/integrity/
>
> +INTEGRITY POLICY ENFORCEMENT (IPE)
> +M:     Fan Wu <wufan@linux.microsoft.com>
> +S:     Supported
> +F:     security/ipe/

You should probably add a mailing list (L:) and source tree URL (T:)
to the IPE entry.  You can use the LSM mailing list to start if you
like, there are several LSMs that do that today, e.g. Smack, Landlock,
etc.  As far as the source tree is concerned, probably the easiest
option is a simple GitHub repo, but there are plenty of other choices
too.

Both the mailing list and the source URLs can always be updated in the
future so don't worry too much about being stuck with either long
term.

--
paul-moore.com
