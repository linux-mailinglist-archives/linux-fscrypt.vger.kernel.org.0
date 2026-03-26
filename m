Return-Path: <linux-fscrypt+bounces-1542-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GOcXB8NcxWkk9gQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1542-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 17:20:19 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D752338433
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 17:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D6AB4302DD53
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 16:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6196329D29F;
	Thu, 26 Mar 2026 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GHTzb5YE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA69382368
	for <linux-fscrypt@vger.kernel.org>; Thu, 26 Mar 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541799; cv=pass; b=aHUsdRHaDqfjFMWfi8rZxM6VrO66bXvfM0QeYxGGmdUhXqTCJxaR8pF0Ty9Us4qb6oTU+SG4wU2c3atXqeID9ALs4ia3S4rrqm6ssX5RfYBf5vn2O9YSShCY6JIlyKV6XLaQ6Vth6bXP8179qLijs0AanvKm/88U4cne5dJQIUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541799; c=relaxed/simple;
	bh=ZmMWtIGFF3qX/n1FkEv/i0UMSWQYCnjKW/3sG5XVFYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMGodANamE+l8FndIiAkviNVW3BHRkBy/qtw3g1UfkkzPFyQOyAsMs6fBpO0A2VzzghoMpzmbnweS/tDqcXdG6yBTrkbovtM4T9VUTX32ZHIBxwMdBkT52GO1UT9yO6YtlburfD3cK6Qb2Zg1KlVuJdr/6brc2EGVyvZTHojWGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GHTzb5YE; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439b94a19fdso1102384f8f.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 26 Mar 2026 09:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774541796; cv=none;
        d=google.com; s=arc-20240605;
        b=Ssh0If5/XoS0lUazNYKhOR9oxL6MEauI675IER40NU/tCYVCiDcXLEAUOrsV6+WV1Y
         iPwMLr4v6NuSbnADzdHxPRaK6pcHR8WYs8NKaio9w5E8UWzjljOmE4OoV7HI/B9i3BLa
         RWnTbkuvPo2/g+GQqpCQ/VUGizVqc2OaGtr+n6JvZgv2Y54cXQxfMQMtk1lzbk+Lz6BM
         oedNg/HZN8seo+aLLojBcpEstmEEfaWEr2KKgncb9eP9qa8npiTBTNLxZhlAzCo7YeH9
         zgMiBk+EZD+tuiR5Ivfsgu53INynmrxlpDSQdmwtmaC5+cKa4tvLnSzpuTXYVXpicAbz
         df0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vKJ5HSJrXHj5MUrcSTPs6jehjmYmFEBs1HNYTNjir5w=;
        fh=c1LqN78kDt+jf7zzJdNhao+XQPOFpts1fjoddtUJPOE=;
        b=TxDRLbRcZcRlON2l+rkg/sqbSdMgcW9n+60QOwE5UDpDxzVgEXW0lJonnPfV4cKWor
         l56JOXsEG6EeqGDUBe/qhXALOlX2LUwxBxLvmy/J3vHZ1ATO+LDuyl45tiJyBiPJ/AHv
         vAGG7hCc9yEKM7sh2hTlx+Rvh6xwWx94lQuRuWykPh4lKy+Q1OApYPJCKhAp1H4VmoWG
         DJyohYjPF3A7Odc8XONWMU5V5rp0FiWgSi5IyUiUJDH7GTHEzYD98G/rdN56/YJuh+QV
         OK+U9EPOi0k95y1mlYI4G4+YBLeK4GjvLgekdC/pJ57virLHGn4iC6eaY9Vm2aTGXEL1
         TAzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774541796; x=1775146596; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vKJ5HSJrXHj5MUrcSTPs6jehjmYmFEBs1HNYTNjir5w=;
        b=GHTzb5YE5S2TLbpNpKL7/TdJUNcdkN7Xx38InyQjmvAm+KS0xaWnOet2OeXU8XeI8h
         RgdeLCaSyQGw8mCrvxTfVc6UKjKQD3gUteeUW79xC4+6EVNbZJyHcbrHgEuPmT7sFnHh
         pPqe45bbdL7ucog9QcAHA3UuMQyCbIh0IYtKkeNOU8TaNi/aNZgq9xj5P5VP1ZJzfnF6
         6H8w1qmC9w9MuGfJmiopq0ubsOW94rZOlYYGN+UuCHsi1xLMcUxK+akD+M7FDGedWsy6
         IlWAKpSGWOS7fzethAADcagjGcgKIv9IltbQY4/fM2w2mqzwN6VhNCvMSaEwztVWyBdm
         4yFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774541796; x=1775146596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKJ5HSJrXHj5MUrcSTPs6jehjmYmFEBs1HNYTNjir5w=;
        b=NZ+X5iSFLTg9QqkKuzOOZ1Auh4JVU3FSy+Paw44/2I0QYXCMW23OiLlDtIi5ZPbSz4
         81VxVhW8JkQT00f5AzIZ3Ik8+08c/Ql3qmtP7bzQzbDpFoqAdUM5VrrqNaWeGmTBvWbj
         TShBwY+tIIjjDufiwbR9PVH09x8dviiMnb3Od0RQHn9J+Fw04X5+ml9XPyGzNvPBLM1d
         FatCiOb7JeDmud/zhR6kFtAnvCn+0BGF78nn4sGsvYCmo0qQYqz4GRFNrhWg2iGpqQDG
         EejRGMWsUMVJ2q+BOzf8vb3+Hgm3y/TCe4uO+C5lsKut6sqeryr0rsZoiHRChhhciISe
         1oFg==
X-Forwarded-Encrypted: i=1; AJvYcCXHchIaMtNoCYUyN5jtutEv49L1NYFajFeDTeXACyQ9zvqXYXt5CTirrHvrcL5iuBRQPVZS+2iYBun44UJ2@vger.kernel.org
X-Gm-Message-State: AOJu0YxrB/y++2WmZ83GIDmVshwAaTSE3AdwXZM2kIlMPlABuZcDR0y3
	n8oLIqN0KjqyuCcVPVtJuXB6P2mYHNfCvVoK4Lbx4RGhJpwRIYDcol1AG3YvMkYKmaquFiYbo90
	H69hA802MpTozkBDJm61vdSi5NsaT/wA4yYKH0PDatQ==
X-Gm-Gg: ATEYQzyuAJBGFfkbizbS7F7svWC6o6n3aOQqtwD3AQApSTHDVT+tvKJusIfA9xo4QQN
	X6mgt5ZpPU9dUkSg78EIkS0cXHw5L89PTvWYoy5QzvQ+FNx1MG4RaRWwMlVlVxBVCSmgAM0Qt06
	tyBB/PGcC+Nw/qaPK0P6fcUwELq0vc0YxCmx2Lrco5FvAmGUlV/ayNYLTTPpb0QFAlBdx58stgY
	RlaJsT9jeAXOn4SWXRn44X4VOQfrWeazJmml4LdRCOt+hwI0RJCzobEL++MMzuRK32hvOeRsjY1
	rK6LJjJOsuqNG5O/HGP07iqDXPBbAgqdvPyWvzKnwJjir1vVslvWEQgQN6pQqIu0vozDCR+SlHo
	rJyBc
X-Received: by 2002:a05:6000:2890:b0:43b:41b5:e023 with SMTP id
 ffacd0b85a97d-43b88995466mr13647132f8f.1.1774541795781; Thu, 26 Mar 2026
 09:16:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-43-neelx@suse.com>
 <20260208131745.2173841-1-clm@meta.com>
In-Reply-To: <20260208131745.2173841-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 26 Mar 2026 17:16:24 +0100
X-Gm-Features: AQROBzAGdUPAvZg0YU6QTXKdWZ2x7caOrhRysbF5k8uC5LR-I02VBBB483yNqVk
Message-ID: <CAPjX3FexW6D4m23OQQ0bNZRCJRfx0Armr3Lb8nvDR_qNMx_PeA@mail.gmail.com>
Subject: Re: [PATCH v6 42/43] btrfs: disable encryption on RAID5/6
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1542-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[suse.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MAILSPIKE_FAIL(0.00)[172.232.135.74:server fail];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: 0D752338433
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 8 Feb 2026 at 14:18, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > The RAID5/6 code will re-arrange bios and submit them through a
> > different mechanism.  This is problematic with inline encryption as we
> > have to get the bio and csum it after it's been encrypted, and the
> > radi5/6 bio's don't have the btrfs_bio embedded, so we have no way to
> > get the csums put on disk.
> >
> > This isn't an unsolvable problem, but would require a bit of reworking.
> > Since we discourage users from using this code currently simply don't
> > allow encryption on RAID5/6 setups.  If there's sufficient demand in the
> > future we can add the support for this.
> >
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
>
> commit 6a39a21e95e116ad02c6ce9f832838acc111692f
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: disable encryption on RAID5/6
>
> The RAID5/6 code will re-arrange bios and submit them through a
> different mechanism to handle parity. This is problematic with inline
> encryption as we have to get the bio and csum it after it's been
> encrypted, and the RAID5/6 bios don't have the btrfs_bio embedded, so
> there's no way to get the csums put on disk.
>
> > commit 6a39a21e95e116ad02c6ce9f832838acc111692f
> > Author: Josef Bacik <josef@toxicpanda.com>
> > Date:   Fri Feb 6 19:23:14 2026 +0100
> >
> >     btrfs: disable encryption on RAID5/6
> >
> >     The RAID5/6 code will re-arrange bios and submit them through a
> >     different mechanism.  This is problematic with inline encryption as we
> >     have to get the bio and csum it after it's been encrypted, and the
> >     radi5/6 bio's don't have the btrfs_bio embedded, so we have no way to
>                                                                        ^^^^
>
> This isn't a bug, but there's a typo: 'radi5/6' should be 'raid5/6'.
>
> [ ... ]
>
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index a8adf99ad0a81..1bade8fea16e8 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -5198,6 +5198,10 @@ long btrfs_ioctl(struct file *file, unsigned int
> >                       return -EOPNOTSUPP;
> >               if (sb_rdonly(fs_info->sb))
> >                       return -EROFS;
> > +             if (btrfs_fs_incompat(fs_info, RAID56)) {
> > +                     btrfs_warn(fs_info, "can't enable encryption with RAID5/6");
> > +                     return -EINVAL;
> > +             }
>
> This check prevents enabling encryption when RAID56 is already active,
> but does NOT prevent converting to RAID5/6 after encryption is enabled.
> The check_raid56_incompat_flag() function in fs/btrfs/volumes.c:5558
> sets the RAID56 flag during balance operations without checking if
> ENCRYPT is already set. This allows users to:
>
> 1. Enable encryption via FS_IOC_SET_ENCRYPTION_POLICY (sets ENCRYPT at
>    line 5210 in this function)
> 2. Later run btrfs balance to convert to RAID5/6 (sets RAID56 flag at
>    volumes.c:5558)
> 3. End up with both ENCRYPT and RAID56 flags set

Indeed this should be sealed. I think this will do:

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5742,6 +5742,11 @@ struct btrfs_block_group
*btrfs_create_chunk(struct btrfs_trans_handle *trans,

     lockdep_assert_held(&info->chunk_mutex);

+    if (btrfs_fs_incompat(info, ENCRYPT)) {
+        btrfs_warn(info, "RAID5/6 not yet supported on encrypted filesystem");
+        return ERR_PTR(-EINVAL);
+    }
+
     if (!alloc_profile_is_valid(type, 0)) {
         DEBUG_WARN("invalid alloc profile for type %llu", type);
         return ERR_PTR(-EINVAL);

> The commit message states "simply don't allow encryption on RAID5/6
> setups" which implies preventing the incompatible state entirely, not
> just one entry path. The volumes.c code path needs a corresponding
> check:
>
> static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
> {
>         if (!(type & BTRFS_BLOCK_GROUP_RAID56_MASK))
>                 return;
>         // MISSING: check for ENCRYPT flag here
>         btrfs_set_fs_incompat(info, RAID56);
> }
>
> Without this check, data corruption can occur via the RAID5/6 bio path
> that cannot handle encrypted data properly, as explained in the commit
> message.
>
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 4a2887147ead4..aefcbe56e85ad 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -734,6 +734,12 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
> >       if (btrfs_check_mountopts_zoned(info, mount_opt))
> >               ret = false;
> >
> > +     if (btrfs_fs_incompat(info, RAID56) &&
> > +         btrfs_raw_test_opt(*mount_opt, TEST_DUMMY_ENCRYPTION)) {
> > +             btrfs_err(info, "cannot use test_dummy_encryption with RAID5/6");
> > +             ret = false;
> > +     }
> > +
>
> Similar to the ioctl.c issue, this prevents mounting with
> test_dummy_encryption when RAID56 is already active, but does NOT
> prevent converting to RAID5/6 after mounting with test_dummy_encryption.
>
> The check_raid56_incompat_flag() function in fs/btrfs/volumes.c:5558
> sets the RAID56 flag during balance operations without checking if
> test_dummy_encryption is in use. Since test_dummy_encryption cannot be
> changed after mount (enforced by btrfs_check_test_dummy_encryption at
> line 1547-1560), a user can:
>
> 1. Mount filesystem with -o test_dummy_encryption
> 2. Later run btrfs balance to convert to RAID5/6 (sets RAID56 flag)
> 3. End up with both test_dummy_encryption active and RAID56 flag set
>
> While test_dummy_encryption is primarily a testing/development feature,
> the patch explicitly protects against this combination, indicating it's
> an important incompatibility. The volumes.c code path needs a check for
> the TEST_DUMMY_ENCRYPTION mount option:
>
> static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
> {
>         if (!(type & BTRFS_BLOCK_GROUP_RAID56_MASK))
>                 return;
>         // MISSING: check for TEST_DUMMY_ENCRYPTION mount option
>         btrfs_set_fs_incompat(info, RAID56);
> }
>
> Does this allow the same encrypted bio / RAID5/6 bio incompatibility
> described in the commit message?

The above fix also covers this case.

Thanks.

--nX

