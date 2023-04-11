Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91766DE6A1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 23:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDKVp5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 17:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDKVp4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 17:45:56 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B79A449E
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 14:45:53 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e10so744988ybp.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 14:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681249552; x=1683841552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJHIYVc0csC12SHK/J/mtXalsO4pjHKd97C3GIyBGPs=;
        b=DBlz2vm4moCxBbqcz1weaSasKWcg+Y71F5kVhWN7HJXD/ZN7d3htDBV70rbXGYWU3t
         CXxT9fxqT9/QnzXL5Nd4wWfo4F0S9G27/nnohdAdRRK+4bONsmM4BvVBIzpOCbcwAeha
         Xy/3h3dUEkfQn6vXeo0795aMl3/fNibaNdnltb95zNJoMMc7l+XJgqL5yZzvzIEqaHpF
         HuYAWlfZWOnEM+Wye80CUORh4piSFA7w5AQbxTd97rqexAdvf8c6ZT1rwMrsR9PEU/VP
         HGzyfkBtzRsmynNQmymKhDcCzgTJ+xjIpLPiLBbn6PV++RgHBtfpqB4xyg2F/X6/HjlC
         QQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681249552; x=1683841552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJHIYVc0csC12SHK/J/mtXalsO4pjHKd97C3GIyBGPs=;
        b=Qox+OgAd8v4ZKoT5RQf0lbaYXT270PC6UpEpU95lQeWQ+OUhA7EwofDSB+zTINnNMI
         2ja9yNwxYVsXB8JD3sBIQyurkZFGNnGH/f9JBDTmuYdztlrNjGqzANHE8V6I07PJBKFV
         GnuT9SfdKl48kkfg+rgq3HDiudW4KLi5N/tBQJ4qjb5jj8p4UJCfH3+LdeV3wNHHeQW4
         5Qcu1+h/NKzuwLhzMOq2eSc37ykBRouhJCWg/XedgL5j2e/9W9u12SnkWjfCKe2M6Mcx
         b97PokKVgVHn5w0zSEiQeh47cV1Tujpya91E71jmR9FV7HJMpPazJUweVnOKna1V2y5M
         3k5g==
X-Gm-Message-State: AAQBX9cwGHuaYHQm8cWFwBPj10XeQAHVMNuAIY/He2lg7SwIXNzDhUI6
        Y8Vf4SYIkyv9myOmzZ4j/xXyEYMy9zUf9q8F9whf
X-Google-Smtp-Source: AKy350Yy44JQPhqwIxfCYnzm9J8mBAXlzIsXMzsUvsaWbKpTAmHS32TjoXQQ8RK1Y2npGScPRJOP30cnOuG8gOZrT1A=
X-Received: by 2002:a25:e0c5:0:b0:b8b:fd23:5028 with SMTP id
 x188-20020a25e0c5000000b00b8bfd235028mr2609635ybg.3.1681249552097; Tue, 11
 Apr 2023 14:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com> <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 11 Apr 2023 17:45:41 -0400
Message-ID: <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 3:10=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wr=
ote:
> > >
> > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > >
> > > As is typical with LSMs, IPE uses securityfs as its interface with
> > > userspace. for a complete list of the interfaces and the respective
> > > inputs/outputs, please see the documentation under
> > > admin-guide/LSM/ipe.rst
> > >
> > > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> >
> > ...
> >
> > > ---
> > >  security/ipe/Makefile    |   2 +
> > >  security/ipe/fs.c        | 101 +++++++++
> > >  security/ipe/fs.h        |  17 ++
> > >  security/ipe/ipe.c       |   3 +
> > >  security/ipe/ipe.h       |   2 +
> > >  security/ipe/policy.c    | 135 ++++++++++++
> > >  security/ipe/policy.h    |   7 +
> > >  security/ipe/policy_fs.c | 459 +++++++++++++++++++++++++++++++++++++=
++
> > >  8 files changed, 726 insertions(+)
> > >  create mode 100644 security/ipe/fs.c
> > >  create mode 100644 security/ipe/fs.h
> > >  create mode 100644 security/ipe/policy_fs.c

...

> > > +/**
> > > + * ipe_update_policy - parse a new policy and replace @old with it.
> > > + * @addr: Supplies a pointer to the i_private for saving policy.
> > > + * @text: Supplies a pointer to the plain text policy.
> > > + * @textlen: Supplies the length of @text.
> > > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message=
.
> > > + * @pkcs7len: Supplies the length of @pkcs7len.
> > > + *
> > > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > > + * ipe_new_policy.
> > > + *
> > > + * Return:
> > > + * * !IS_ERR   - OK
> > > + * * -ENOENT   - Policy doesn't exist
> > > + * * -EINVAL   - New policy is invalid
> > > + */
> > > +struct ipe_policy *ipe_update_policy(struct ipe_policy __rcu **addr,
> > > +                                    const char *text, size_t textlen=
,
> > > +                                    const char *pkcs7, size_t pkcs7l=
en)
> > > +{
> > > +       int rc =3D 0;
> > > +       struct ipe_policy *old, *new;
> > > +
> > > +       old =3D ipe_get_policy_rcu(*addr);
> > > +       if (!old) {
> > > +               rc =3D -ENOENT;
> > > +               goto err;
> > > +       }
> > > +
> > > +       new =3D ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > > +       if (IS_ERR(new)) {
> > > +               rc =3D PTR_ERR(new);
> > > +               goto err;
> > > +       }
> > > +
> > > +       if (strcmp(new->parsed->name, old->parsed->name)) {
> > > +               rc =3D -EINVAL;
> > > +               goto err;
> > > +       }
> > > +
> > > +       if (ver_to_u64(old) > ver_to_u64(new)) {
> > > +               rc =3D -EINVAL;
> > > +               goto err;
> > > +       }
> > > +
> > > +       if (ipe_is_policy_active(old)) {
> >
> > I don't understand the is-active check, you want to make @new the new
> > active policy regardless, right?  Could this is-active check ever be
> > false?
>
> Actually this is needed. Policy updates can be applied to any deployed
> policy, which may be saved in two places: the securityfs file node
> and the ipe_active_policy pointer. To update a policy, this function firs=
t
> checks if the policy saved in the securityfs file node is currently activ=
e.
> If so, it updates the ipe_active_policy pointer to point to the new polic=
y,
> and finally updates the policy pointer in the securityfs to the new polic=
y.

Ah, okay.  I must have forgotten, or not realized, that multiple
policies could be loaded and not active.

I guess this does make me wonder about keeping a non-active policy
loaded in the kernel, what purpose does that serve?

--=20
paul-moore.com
