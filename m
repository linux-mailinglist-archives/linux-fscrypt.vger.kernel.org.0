Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891317DE997
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 01:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjKBAmJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Nov 2023 20:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbjKBAmI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Nov 2023 20:42:08 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC79130
        for <linux-fscrypt@vger.kernel.org>; Wed,  1 Nov 2023 17:42:00 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-d865854ef96so369940276.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Nov 2023 17:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698885720; x=1699490520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfm/0AKufdPiFJYHbTbOpMAv0XgVJ1QQxTCxWlRvibI=;
        b=AAK+l3S5oPsVog/q8f0YXEaVb1JruGwr4HueHv5uiA1BjVB0fLHWJRtxn6Zjb8iyZ4
         kiGjx3fDWc0OT+biXsz/KPcpIb6HM2NmJ0oez1ewDZ2hr5XbMQRENtDQnrUdXgj/w/Tf
         ZCx/csxR6TYPxwrb43CTW8Bicay3sVruvDXsIQH517dFHfUO1oRJl4SWWEWInHA7Mb+a
         H4beS3hr1Mgx56uh5omgmFCM4JF7G6kmjgG6bs9zj1yx9HQy3WGAFadM1EOa0BAZ4N/w
         T80zMIsRJGMtgUBQvtdkYAEYVcL00LPBiDZp6PhElw8thrl4CA6+qDUG1mbXKCa/u/iy
         UazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698885720; x=1699490520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfm/0AKufdPiFJYHbTbOpMAv0XgVJ1QQxTCxWlRvibI=;
        b=vfHR9mFKOyi3EMTZ4zF3bMc0VAz/wUZrSPJQHsoQmv7IXrei42W0fBB5/dyU3DyFyI
         Jd95TooiaetStUIIN3rLtv5GB3wyfsj3zATOHwXpzqWg7Zz1BMGEyPmQ2hIewMtbqPIq
         50tIXm9BBs9imiSE3crNXH3XByP26tHh4MlesiE0LN8vsJx9NBgIH4ibKDxppx/LVSZC
         crJ4wviFNll8SL2IzYgX5jRK43NEUhYs0esLMknvGrRBEv8okgFmWQgGVN+RCLC4/tN0
         M3qEN5FY3T0CLai/xFNGJHlhr7JDsmi1rxVlxsdqui5GPrple8vLGqy3367JjHn6avir
         fisw==
X-Gm-Message-State: AOJu0Yx3dJAjSDKzi1ZDfcPBLajXFlap8Oj6vCIGcgHspUhosrHQo/nM
        TVp/f7o6nKNgTjYlOX6vqhA3nbxORcfrSgLc4fUV
X-Google-Smtp-Source: AGHT+IG56W6WaZP1Vrnv6N6PpJNY0stJMJVwbIZMHQlNXxmU3o7A/fNrHvG8Fz7OytCab6Lm2+OmJrBj+gKDl9Z2Rd4=
X-Received: by 2002:a25:cf4a:0:b0:d9a:c4cf:a067 with SMTP id
 f71-20020a25cf4a000000b00d9ac4cfa067mr19260286ybg.35.1698885720051; Wed, 01
 Nov 2023 17:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <1696457386-3010-14-git-send-email-wufan@linux.microsoft.com> <1e9658bed9b583c9d6cf07c13253cf8f.paul@paul-moore.com>
In-Reply-To: <1e9658bed9b583c9d6cf07c13253cf8f.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 1 Nov 2023 20:41:49 -0400
Message-ID: <CAHC9VhQpXaEbCzOh7FjOn9dC6LKKWVpzmn_FQK0YSufdbNEEGw@mail.gmail.com>
Subject: Re: [PATCH RFC v11 13/19] dm verity: consume root hash digest and
 signature data via LSM hook
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
>
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > dm-verity provides a strong guarantee of a block device's integrity. As
> > a generic way to check the integrity of a block device, it provides
> > those integrity guarantees to its higher layers, including the filesyst=
em
> > level.
> >
> > An LSM that control access to a resource on the system based on the
> > available integrity claims can use this transitive property of
> > dm-verity, by querying the underlying block_device of a particular
> > file.
> >
> > The digest and signature information need to be stored in the block
> > device to fulfill the next requirement of authorization via LSM policy.
> > This will enable the LSM to perform revocation of devices that are stil=
l
> > mounted, prohibiting execution of files that are no longer authorized
> > by the LSM in question.
> >
> > This patch added two security hook calls in dm-verity to save the
> > dm-verity roothash and the roothash signature to the block device's
> > LSM blobs.
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> > v2:
> >   + No Changes
> >
> > v3:
> >   + No changes
> >
> > v4:
> >   + No changes
> >
> > v5:
> >   + No changes
> >
> > v6:
> >   + Fix an improper cleanup that can result in
> >     a leak
> >
> > v7:
> >   + Squash patch 08/12, 10/12 to [11/16]
> >   + Use part0 for block_device, to retrieve the block_device, when
> >     calling security_bdev_setsecurity
> >
> > v8:
> >   + Undo squash of 08/12, 10/12 - separating drivers/md/ from
> >     security/ & block/
> >   + Use common-audit function for dmverity_signature.
> >   + Change implementation for storing the dm-verity digest to use the
> >     newly introduced dm_verity_digest structure introduced in patch
> >     14/20.
> >   + Create new structure, dm_verity_digest, containing digest algorithm=
,
> >     size, and digest itself to pass to the LSM layer. V7 was missing th=
e
> >     algorithm.
> >   + Create an associated public header containing this new structure an=
d
> >     the key values for the LSM hook, specific to dm-verity.
> >   + Additional information added to commit, discussing the layering of
> >     the changes and how the information passed will be used.
> >
> > v9:
> >   + No changes
> >
> > v10:
> >   + No changes
> >
> > v11:
> >   + Add an optional field to save signature
> >   + Move the security hook call to the new finalize hook
> > ---
> >  drivers/md/dm-verity-target.c | 71 +++++++++++++++++++++++++++++++++++
> >  drivers/md/dm-verity.h        |  6 +++
> >  include/linux/dm-verity.h     | 19 ++++++++++
> >  3 files changed, 96 insertions(+)
> >  create mode 100644 include/linux/dm-verity.h
>
> We need an ACK from Alasdair and/or Mike on this too.

A gentle ping with a reminder ...

For reference, the full patchset can be found on lore at the link below:

https://lore.kernel.org/linux-security-module/1696457386-3010-1-git-send-em=
ail-wufan@linux.microsoft.com/

> > diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-targe=
t.c
> > index 80673b66c194..db58b53649e3 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -13,6 +13,7 @@
> >   * access behavior.
> >   */
> >
> > +#include "dm-core.h"
> >  #include "dm-verity.h"
> >  #include "dm-verity-fec.h"
> >  #include "dm-verity-verify-sig.h"
> > @@ -22,6 +23,9 @@
> >  #include <linux/scatterlist.h>
> >  #include <linux/string.h>
> >  #include <linux/jump_label.h>
> > +#include <linux/security.h>
> > +#include <linux/dm-verity.h>
> > +#include <crypto/hash_info.h>
> >
> >  #define DM_MSG_PREFIX                        "verity"
> >
> > @@ -952,6 +956,17 @@ static void verity_io_hints(struct dm_target *ti, =
struct queue_limits *limits)
> >       blk_limits_io_min(limits, limits->logical_block_size);
> >  }
> >
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +static void verity_free_sig(struct dm_verity *v)
> > +{
> > +     kfree(v->root_digest_sig);
> > +}
> > +#else
> > +static inline void verity_free_sig(struct dm_verity *v)
> > +{
> > +}
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> > +
> >  static void verity_dtr(struct dm_target *ti)
> >  {
> >       struct dm_verity *v =3D ti->private;
> > @@ -966,6 +981,7 @@ static void verity_dtr(struct dm_target *ti)
> >       kfree(v->salt);
> >       kfree(v->root_digest);
> >       kfree(v->zero_digest);
> > +     verity_free_sig(v);
> >
> >       if (v->tfm)
> >               crypto_free_ahash(v->tfm);
> > @@ -1157,6 +1173,25 @@ static int verity_parse_opt_args(struct dm_arg_s=
et *as, struct dm_verity *v,
> >       return r;
> >  }
> >
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +static int verity_init_sig(struct dm_verity *v, const void *sig,
> > +                        size_t sig_size)
> > +{
> > +     v->sig_size =3D sig_size;
> > +     v->root_digest_sig =3D kmalloc(v->sig_size, GFP_KERNEL);
> > +     if (!v->root_digest)
> > +             return -ENOMEM;
> > +
> > +     return 0;
> > +}
> > +#else
> > +static inline int verity_init_sig(struct dm_verity *v, const void *sig=
,
> > +                               size_t sig_size)
> > +{
> > +     return 0;
> > +}
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> > +
> >  /*
> >   * Target parameters:
> >   *   <version>       The current format is version 1.
> > @@ -1365,6 +1400,13 @@ static int verity_ctr(struct dm_target *ti, unsi=
gned int argc, char **argv)
> >               ti->error =3D "Root hash verification failed";
> >               goto bad;
> >       }
> > +
> > +     r =3D verity_init_sig(v, verify_args.sig, verify_args.sig_size);
> > +     if (r < 0) {
> > +             ti->error =3D "Cannot allocate root digest signature";
> > +             goto bad;
> > +     }
> > +
> >       v->hash_per_block_bits =3D
> >               __fls((1 << v->hash_dev_block_bits) / v->digest_size);
> >
> > @@ -1501,6 +1543,32 @@ int dm_verity_get_root_digest(struct dm_target *=
ti, u8 **root_digest, unsigned i
> >       return 0;
> >  }
> >
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +static int verity_finalize(struct dm_target *ti)
> > +{
> > +     struct block_device *bdev;
> > +     struct dm_verity_digest root_digest;
> > +     struct dm_verity *v;
> > +     int r;
> > +
> > +     v =3D ti->private;
> > +     bdev =3D dm_table_get_md(ti->table)->disk->part0;
> > +     root_digest.digest =3D v->root_digest;
> > +     root_digest.digest_len =3D v->digest_size;
> > +     root_digest.algo =3D v->alg_name;
> > +
> > +     r =3D security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME=
, &root_digest,
> > +                                   sizeof(root_digest));
> > +     if (r)
> > +             return r;
> > +
> > +     return security_bdev_setsecurity(bdev,
> > +                                      DM_VERITY_SIGNATURE_SEC_NAME,
> > +                                      v->root_digest_sig,
> > +                                      v->sig_size);
> > +}
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> > +
> >  static struct target_type verity_target =3D {
> >       .name           =3D "verity",
> >       .features       =3D DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
> > @@ -1513,6 +1581,9 @@ static struct target_type verity_target =3D {
> >       .prepare_ioctl  =3D verity_prepare_ioctl,
> >       .iterate_devices =3D verity_iterate_devices,
> >       .io_hints       =3D verity_io_hints,
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +     .finalize       =3D verity_finalize,
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> >  };
> >  module_dm(verity);
> >
> > diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> > index 2f555b420367..a093d4a54615 100644
> > --- a/drivers/md/dm-verity.h
> > +++ b/drivers/md/dm-verity.h
> > @@ -42,6 +42,9 @@ struct dm_verity {
> >       u8 *root_digest;        /* digest of the root block */
> >       u8 *salt;               /* salt: its size is salt_size */
> >       u8 *zero_digest;        /* digest for a zero block */
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +     u8 *root_digest_sig;    /* digest signature of the root block */
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> >       unsigned int salt_size;
> >       sector_t data_start;    /* data offset in 512-byte sectors */
> >       sector_t hash_start;    /* hash start in blocks */
> > @@ -55,6 +58,9 @@ struct dm_verity {
> >       bool hash_failed:1;     /* set if hash of any block failed */
> >       bool use_tasklet:1;     /* try to verify in tasklet before work-q=
ueue */
> >       unsigned int digest_size;       /* digest size for the current ha=
sh algorithm */
> > +#ifdef CONFIG_IPE_PROP_DM_VERITY
> > +     unsigned int sig_size;  /* digest signature size */
> > +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> >       unsigned int ahash_reqsize;/* the size of temporary space for cry=
pto */
> >       enum verity_mode mode;  /* mode for handling verification errors =
*/
> >       unsigned int corrupted_errs;/* Number of errors for corrupted blo=
cks */
> > diff --git a/include/linux/dm-verity.h b/include/linux/dm-verity.h
> > new file mode 100644
> > index 000000000000..bb0413d55d72
> > --- /dev/null
> > +++ b/include/linux/dm-verity.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_DM_VERITY_H
> > +#define _LINUX_DM_VERITY_H
> > +
> > +#include <linux/types.h>
> > +#include <crypto/hash_info.h>
> > +#include <linux/device-mapper.h>
> > +
> > +struct dm_verity_digest {
> > +     const char *algo;
> > +     const u8 *digest;
> > +     size_t digest_len;
> > +};
> > +
> > +#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME ".verity-signature"
> > +#define DM_VERITY_ROOTHASH_SEC_NAME  DM_NAME ".verity-roothash"
> > +
> > +#endif /* _LINUX_DM_VERITY_H */
> > --
> > 2.25.1

--=20
paul-moore.com
