Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11EF6A890C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCBTGu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCBTGt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:06:49 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BE56792
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:06:25 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id cp12so95149pfb.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677783979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5esfVLMIlaF9LP/rwwpmV4S1kF4WuSj7Z9THxqYwh0=;
        b=c4iW+83zLTwJooQrpOiMvAFRHbVlYtPAgjZV60FCyNFRYyF5+feuQEYtfdTSEaMayB
         gW87KBDJ0hcTIzLA7TPatuuGTIp+/B7XDO0l9Ej7nSuvJwDMkdhIhfVC+nhsJxaT/vsT
         f34a89IKFFLsGwIFPaaD2WCX9yFv6D5GrTqz7pnAo48tJi7lh1JdxdKJJ+ZOe9Cc91Cj
         Ucx95ZaUEu8AFO02oL4arCEA3rPYRRRIhbmvzYw/bkI5eR1CymRmovxCulYAgalK4Ymb
         TU+7cJiNPP2nikjQT/SIkVdvTYdyjT5ig1g5Bfhcu/xcVxsrWLKeExmjoZ3llFgluWDM
         i4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677783979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5esfVLMIlaF9LP/rwwpmV4S1kF4WuSj7Z9THxqYwh0=;
        b=O9ojQg4jdQM1x+/YoIXWFkM8nV6kMWb7JCd9fSL9//u1ELOCRk7777dsl6MV8BIkJl
         F0iMNAyJOBpDLUPvOhya7kbNTWo23wvyHi3x/dAFYsGPaGXqY1IIG0HQTrti+qZbrPaJ
         HzDgFblAMm3C/FTEtfVAxYjgg+y2jHaRdpVNGr9hiVHr0UmuBHZXYjJZb12ndxllYuwV
         noi3B8eINuEglKstCEXGkJkUpSDf6/eH3UxL7kPzfEJEXZyXm6qLJHUWygObj0dpzGIu
         +um1wsEKlLtKRXzLn6cm1P68EXX7N3vVMEC/Ei2bsbUOI+yEZAbXssbgl43MBfWifbVq
         Ukog==
X-Gm-Message-State: AO0yUKWb/J0VTEyZ6emw0PFzg7ksxIuRfs3dHTYikaHwIK6foIh/5zAF
        oqTO2gRa9w1Qds4EMIAfCcKmQo5SyEDE1yGe0ZMe
X-Google-Smtp-Source: AK7set8PWvLY+rxaVR0TcpyjbBjhxaI/Z6/f+upjt6eV1DGDo8C8lKrfXPzkHebf+bbYeLsHccZvtjxtnFnLroRq9ZY=
X-Received: by 2002:a63:8c1d:0:b0:503:2535:44c3 with SMTP id
 m29-20020a638c1d000000b00503253544c3mr3673307pgd.4.1677783979154; Thu, 02 Mar
 2023 11:06:19 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-9-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:06:08 -0500
Message-ID: <CAHC9VhTh+z7O353Qc86kqF8URf0QfErG1qHPvzXCgH+6c-AJ4g@mail.gmail.com>
Subject: Re: [RFC PATCH v9 08/16] ipe: add permissive toggle
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
> IPE, like SELinux, supports a permissive mode. This mode allows policy
> authors to test and evaluate IPE policy without it effecting their
> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> be reported.
>
> This patch adds the following audit records:
>
>   audit: MAC_STATUS permissive=3D1 auid=3D4294967295 ses=3D4294967295 lsm=
=3Dipe
>     res=3D1
>   audit: MAC_STATUS permissive=3D0 auid=3D4294967295 ses=3D4294967295 lsm=
=3Dipe
>     res=3D1
>
> These records are emitted within the following events:
>
>   audit: MAC_STATUS permissive=3D1 auid=3D4294967295 ses=3D4294967295 lsm=
=3Dipe
>     res=3D1
>   audit[185]: SYSCALL arch=3Dc000003e syscall=3D1 success=3Dyes exit=3D2 =
a0=3D1
>     a1=3D56308bb3ecc0 a2=3D2 a3=3D7f290fdc53e0 items=3D0 ppid=3D183 pid=
=3D185
>     auid=3D4294967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D=
0 sgid=3D0 fsgid=3D0
>     tty=3Dpts0 ses=3D4294967295 comm=3D"bash" exe=3D"/usr/bin/bash" key=
=3D(null)
>   audit: PROCTITLE proctitle=3D"-bash"
>   audit: MAC_STATUS permissive=3D0 auid=3D4294967295 ses=3D4294967295 lsm=
=3Dipe
>     res=3D1
>   audit[185]: SYSCALL arch=3Dc000003e syscall=3D1 success=3Dyes exit=3D2 =
a0=3D1
>     a1=3D56308bb3ecc0 a2=3D2 a3=3D7f290fdc53e0 items=3D0 ppid=3D183 pid=
=3D185
>     auid=3D4294967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D=
0 sgid=3D0 fsgid=3D0
>     tty=3Dpts0 ses=3D4294967295 comm=3D"bash" exe=3D"/usr/bin/bash" key=
=3D(null)
>   audit: PROCTITLE proctitle=3D"-bash"
>
>   Implying user used bash to toggle the switch.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

...

> ---
>  security/ipe/audit.c | 36 +++++++++++++++++++++++
>  security/ipe/audit.h |  1 +
>  security/ipe/eval.c  |  9 ++++++
>  security/ipe/eval.h  |  1 +
>  security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 114 insertions(+), 2 deletions(-)
>
> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index 295e9f9f5146..ff74026a595f 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -194,3 +194,39 @@ void ipe_audit_policy_load(const struct ipe_policy *=
const p)
>
>         audit_log_end(ab);
>  }
> +
> +/**
> + * ipe_audit_enforce - Audit a change in IPE's enforcement state.
> + */
> +void ipe_audit_enforce(void)
> +{
> +       struct audit_buffer *ab;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STA=
TUS);
> +       if (!ab)
> +               return;
> +
> +       audit_log_format(ab, "permissive=3D%d", !READ_ONCE(enforce));
> +       audit_log_format(ab, " auid=3D%u ses=3D%u lsm=3Dipe res=3D1",
> +                        from_kuid(&init_user_ns, audit_get_loginuid(curr=
ent)),
> +                        audit_get_sessionid(current));
> +
> +       audit_log_end(ab);
> +}

See the earlier comments in the patchset about consistent formatting
of a given record type.  To the best of my knowledge only SELinux
currently uses the AUDIT_MAC_STATUS record and an example can be found
in `sel_write_enforce()`.  The good news is that it looks like that
format could be made to work here without too much fuss.

> +/**
> + * emit_enforcement - Emit the enforcement state of IPE started with.
> + *
> + * Return:
> + * 0 - Always
> + */
> +static int emit_enforcement(void)
> +{
> +       if (!ipe_enabled)
> +               return -EOPNOTSUPP;
> +
> +       ipe_audit_enforce();
> +       return 0;
> +}
> +
> +late_initcall(emit_enforcement);

--
paul-moore.com
