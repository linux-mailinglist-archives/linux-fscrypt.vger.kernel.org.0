Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565236DE7FA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Apr 2023 01:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDKXWK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 19:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDKXWF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 19:22:05 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F73330C7
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 16:22:04 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e127so9966000ybf.8
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 16:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681255323; x=1683847323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjieG96zBNQQG2PDV49OxJZ6+3G2K7bw1ZbVf6U1lzk=;
        b=JBJa4Zkia5CL2Y2OupdXMM4PasK18pInJvMWdC+fcjeXMUtF7Az9LU/h0gwzthGF+x
         QFe+EM5gj0HfuwGanmiaXQwO3fOP8a4btCGAetQJYVHjOzucbpsePzuKkG8TR93btov3
         ejiAzOSugxLP10TJ9faOUK77CIu/bvXaG3edhovV1FmhkPF7ahaMosgu3K9FFeA+6IjP
         qeh/0RVlrXKpAWpHVnAzwGCVyfYKB4mFnhjuGQJsrwBkOB5Jy3rtKOUgPR1BJr7DIua1
         Fk/CkDcSU3fo0g3DUTmWuoTiaScyOwO7RNznY6OmT+Asa5k3Dvwtdp4bTuSz6pIhq7XJ
         tChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681255323; x=1683847323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjieG96zBNQQG2PDV49OxJZ6+3G2K7bw1ZbVf6U1lzk=;
        b=pWPIUe1DLJMU7wliqB4uMDKi1xCWMMRXOvWPNhzIDADl4AH4n5v8aEujPOGdl2ExK2
         QykqZ9i9TZmJxWMj+qA/Gom33FlmyParMJ2W9TPVQlDUofe6ediHyeZSNVooWwD1Nbq6
         BWPITv50zHVpMuDXFBCPHa+2nwedlKv8meCpelJu3NRQfJaXnmJQsGrQINL+8wkt+3d7
         xkgTPvD0uFDUgTi7gU1pnZ1Jbh9SM5oy4mvuumKyhHS2eDX8b/WNHkTvC4ax2GGYKxZe
         L5QxlMC5090NgK3Iu05TebZEef5nffHiaP0ejLzOVcNuPlHPaMDI7/qVVqJyrWvBojg2
         hLng==
X-Gm-Message-State: AAQBX9dMz4xjCKbGOMeeDjdaGnlNS9ygxP5fK5tIdNhRBzw7gnfjqDSP
        B2twdpSQq8a5RR9ttrNqphQvfN2Fml9bq+3mYS+Y
X-Google-Smtp-Source: AKy350Y8Rhd9rHz1qCSxaAF3gL9UQq1FI0yq/mFrHh6N2pKJ6DGoHbpLYYEOHTWZcax61zY11aqLEAa5SLJ9oKG9DsM=
X-Received: by 2002:a25:cace:0:b0:b8f:2f68:93b0 with SMTP id
 a197-20020a25cace000000b00b8f2f6893b0mr1197248ybg.3.1681255323520; Tue, 11
 Apr 2023 16:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2> <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
In-Reply-To: <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 11 Apr 2023 19:21:52 -0400
Message-ID: <CAHC9VhSt1TzpkqGKGXy-4RDBqSQ5+1D9D2JwN1Rw-5G=b=uy3g@mail.gmail.com>
Subject: Re: [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe auditing support
To:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, Fan Wu <wufan@linux.microsoft.com>,
        dm-devel@redhat.com, linux-doc@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
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

On Thu, Mar 2, 2023 at 2:05=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Tue, Jan 31, 2023 at 12:11=E2=80=AFPM Steve Grubb <sgrubb@redhat.com> =
wrote:
> > On Monday, January 30, 2023 5:57:22 PM EST Fan Wu wrote:

...

> > >   audit: MAC_POLICY_LOAD policy_name=3D"dmverity_roothash"
> > >     policy_version=3D0.0.0 sha256=3DDC67AC19E05894EFB3170A8E55DE52979=
4E248C2
> > >     auid=3D4294967295 ses=3D4294967295 lsm=3Dipe res=3D1
> >
> > The MAC_POLICY_LOAD record type simply states the lsm that had it's pol=
icy
> > loaded. There isn't name, version, and hash information. I'd prefer to =
see
> > all users of this record type decide if it should be extended because t=
hey
> > also have that information available to record.
>
> Not all LSMs which load policy have that information; as an example,
> SELinux doesn't have the concept of a policy name or version.  The
> SELinux policy version you might see in the kernel sources refers to
> the policy format version and has no bearing on the actual policy
> content beyond that dictated by the format.
>
> If additional information is required by IPE, perhaps an auxiliary IPE
> policy load record could be created with those additional fields.

The issue of policy load audit records came up in an offline
discussion with Fan today and I think it's worth talking about this a
bit more to reach some consensus.

Currently only SELinux generates MAC_POLICY_LOAD records, and it
contains all of the information that is present in the IPE example
above with the exception of the 'policy_name', 'policy_version', and
the policy digest.  I personally don't have a problem extending the
MAC_POLICY_LOAD record with these fields, and leaving them unused/"?"
in the SELinux generated records.  It's possible we may even want to
use the policy digest field at some point, as it would be nice to be
able to have some policy "key" within SELinux that could be used to
help identify the loaded policy.

The only catch is that we may want to find a better field name than
just 'sha256', in the context of the MAC_POLICY_LOAD record it seems
easily understood, but in the larger context of a full audit stream it
might be too ambiguous.  We would also need to decide if we wanted to
encode the digest algorithm in the field name, the field value, or
have it as a separate field.  I might lean towards encoding it in the
field value like this:

  policy_digest=3Dsha256:XXXXX

... however that is something that would need some discussion from the
other folks on the To/CC line.

--=20
paul-moore.com
