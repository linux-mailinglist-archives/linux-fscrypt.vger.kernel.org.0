Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4E27DE985
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 01:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjKBAk3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Nov 2023 20:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjKBAk2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Nov 2023 20:40:28 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E70E110
        for <linux-fscrypt@vger.kernel.org>; Wed,  1 Nov 2023 17:40:18 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-d84f18e908aso405173276.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Nov 2023 17:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698885617; x=1699490417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqFTar32ASbvPrjveH78MV7Rh5xk6Ufja7S8f/Bljs0=;
        b=F7mWy0sDxS2NsZq4r0QIIkweMjFgefI5B9XATldwoY88ve/PPhdiO6WPTlCRZzZKYH
         bDAL7W3bJxXiOJ0tdx4Oars+508WwIqhuqekUkgZD6Kb6UhFk0q2Tl0baDFvH+0eotKR
         242gTFN2/4qwp3Mt8DWC447jdlMMPTvPfMjumv1oPnP7lMq7CKDlxhTYm5KTON3NCoNV
         oU2XaTDUkxocJG0bR7yLUf9xyWKv6b02FIRYAtZ3biraiF7Qq2R9xLINkiSCYFzTmqxc
         OTBpwVzjfD+HLWavnU5OuO7RaMH9DhPxo6jRfyHL/h18I27yuPQRGDWSsHDo4FKV0SlS
         fmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698885617; x=1699490417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqFTar32ASbvPrjveH78MV7Rh5xk6Ufja7S8f/Bljs0=;
        b=QAg1r3VTdY5TjrG8tT7Sjfptry1xVbeXNIl8cYXT3XMgtfjyGV4q/2AI4ebtFec5Cj
         eY3eB9yxqxJh4jDgr1CMmE56u2LNp5Lbu36KCmWohc3AhQneAquVt18uVR4MPUODa/Wd
         4ZskSuiSDGZrNTUERVjcFh4dOM8DBWjCumTHYSNxLS5u/caT6jRMCNANDGk312TWDXrP
         jJrRdwlK/QCZ6d4UhqSsY9fonVOrHRgMUsbFjonU0/qvSrqaVPnZqMhtV/cxPOEqhBDU
         OsiGCVpZHzHBk+jZAylCv/8JuPuVFbruXzDCoq6n64Z0TknspEs9MicMy84K9F7bveYM
         RQGA==
X-Gm-Message-State: AOJu0YzoY9C/xo78kaaapNU5PkMA6fhldftc1kt5QfDCuhOuiVdOdQW6
        A5gYGeCIYA56aKeTijjozlTeyF2DIiGYrd9peB0f
X-Google-Smtp-Source: AGHT+IGK/PhuZ+UhDDHZYM1Pa72OuOxp0eZOylk1ZmSUvvPb8Alc5ldvSn4N3nj0JccWeXvYLwtkGk3oqNifU7yZ4Jo=
X-Received: by 2002:a25:da82:0:b0:da0:5ff5:5df7 with SMTP id
 n124-20020a25da82000000b00da05ff55df7mr17332747ybf.12.1698885617167; Wed, 01
 Nov 2023 17:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com> <6efb7a80ba0eb3e02b3ae7a5c0a210f3.paul@paul-moore.com>
In-Reply-To: <6efb7a80ba0eb3e02b3ae7a5c0a210f3.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 1 Nov 2023 20:40:06 -0400
Message-ID: <CAHC9VhQJkcb-k+o+NvVn7crrMMZqpBcZpnEbKBT+eZg4Ocjqhw@mail.gmail.com>
Subject: Re: [PATCH RFC v11 15/19] fsverity: consume builtin signature via LSM hook
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 23, 2023 at 11:52=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > fsverity represents a mechanism to support both integrity and
> > authenticity protection of a file, supporting both signed and unsigned
> > digests.
> >
> > An LSM which controls access to a resource based on authenticity and
> > integrity of said resource, can then use this data to make an informed
> > decision on the authorization (provided by the LSM's policy) of said
> > claim.
> >
> > This effectively allows the extension of a policy enforcement layer in
> > LSM for fsverity, allowing for more granular control of how a
> > particular authenticity claim can be used. For example, "all (built-in)
> > signed fsverity files should be allowed to execute, but only these
> > hashes are allowed to be loaded as kernel modules".
> >
> > This enforcement must be done in kernel space, as a userspace only
> > solution would fail a simple litmus test: Download a self-contained
> > malicious binary that never touches the userspace stack. This
> > binary would still be able to execute.
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> > v1-v6:
> >   + Not present
> >
> > v7:
> >   Introduced
> >
> > v8:
> >   + Split fs/verity/ changes and security/ changes into separate patche=
s
> >   + Change signature of fsverity_create_info to accept non-const inode
> >   + Change signature of fsverity_verify_signature to accept non-const i=
node
> >   + Don't cast-away const from inode.
> >   + Digest functionality dropped in favor of:
> >     ("fs-verity: define a function to return the integrity protected
> >       file digest")
> >   + Reworded commit description and title to match changes.
> >   + Fix a bug wherein no LSM implements the particular fsverity @name
> >     (or LSM is disabled), and returns -EOPNOTSUPP, causing errors.
> >
> > v9:
> >   + No changes
> >
> > v10:
> >   + Rename the signature blob key
> >   + Cleanup redundant code
> >   + Make the hook call depends on CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> >
> > v11:
> >   + No changes
> > ---
> >  fs/verity/fsverity_private.h |  2 +-
> >  fs/verity/open.c             | 26 +++++++++++++++++++++++++-
> >  include/linux/fsverity.h     |  2 ++
> >  3 files changed, 28 insertions(+), 2 deletions(-)
>
> We need an ACK from some VFS folks on this.

Eric and/or Ted, can we get either an ACK or some feedback on this patch?

For reference, the full patchset can be found on lore at the link below:

https://lore.kernel.org/linux-security-module/1696457386-3010-1-git-send-em=
ail-wufan@linux.microsoft.com/

> > diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.=
h
> > index d071a6e32581..4a82716e852f 100644
> > --- a/fs/verity/fsverity_private.h
> > +++ b/fs/verity/fsverity_private.h
> > @@ -108,7 +108,7 @@ int fsverity_init_merkle_tree_params(struct merkle_=
tree_params *params,
> >                                    unsigned int log_blocksize,
> >                                    const u8 *salt, size_t salt_size);
> >
> > -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> > +struct fsverity_info *fsverity_create_info(struct inode *inode,
> >                                          struct fsverity_descriptor *de=
sc);
> >
> >  void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
> > diff --git a/fs/verity/open.c b/fs/verity/open.c
> > index 6c31a871b84b..5b48e2c39086 100644
> > --- a/fs/verity/open.c
> > +++ b/fs/verity/open.c
> > @@ -8,6 +8,7 @@
> >  #include "fsverity_private.h"
> >
> >  #include <linux/mm.h>
> > +#include <linux/security.h>
> >  #include <linux/slab.h>
> >
> >  static struct kmem_cache *fsverity_info_cachep;
> > @@ -172,12 +173,28 @@ static int compute_file_digest(const struct fsver=
ity_hash_alg *hash_alg,
> >       return err;
> >  }
> >
> > +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> > +static int fsverity_inode_setsecurity(struct inode *inode,
> > +                                   struct fsverity_descriptor *desc)
> > +{
> > +     return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME=
,
> > +                                       desc->signature,
> > +                                       le32_to_cpu(desc->sig_size), 0)=
;
> > +}
> > +#else
> > +static inline int fsverity_inode_setsecurity(struct inode *inode,
> > +                                          struct fsverity_descriptor *=
desc)
> > +{
> > +     return 0;
> > +}
> > +#endif /* CONFIG_IPE_PROP_FS_VERITY*/
> > +
> >  /*
> >   * Create a new fsverity_info from the given fsverity_descriptor (with=
 optional
> >   * appended builtin signature), and check the signature if present.  T=
he
> >   * fsverity_descriptor must have already undergone basic validation.
> >   */
> > -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> > +struct fsverity_info *fsverity_create_info(struct inode *inode,
> >                                          struct fsverity_descriptor *de=
sc)
> >  {
> >       struct fsverity_info *vi;
> > @@ -242,6 +259,13 @@ struct fsverity_info *fsverity_create_info(const s=
truct inode *inode,
> >               spin_lock_init(&vi->hash_page_init_lock);
> >       }
> >
> > +     err =3D fsverity_inode_setsecurity(inode, desc);
> > +     if (err =3D=3D -EOPNOTSUPP)
> > +             err =3D 0;
> > +
> > +     if (err)
> > +             goto fail;
> > +
> >       return vi;
> >
> >  fail:
> > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > index 1eb7eae580be..9666721baf15 100644
> > --- a/include/linux/fsverity.h
> > +++ b/include/linux/fsverity.h
> > @@ -319,4 +319,6 @@ static inline int fsverity_prepare_setattr(struct d=
entry *dentry,
> >       return 0;
> >  }
> >
> > +#define FS_VERITY_INODE_SEC_NAME "fsverity.builtin-sig"
> > +
> >  #endif       /* _LINUX_FSVERITY_H */
> > --
> > 2.25.1

--=20
paul-moore.com
