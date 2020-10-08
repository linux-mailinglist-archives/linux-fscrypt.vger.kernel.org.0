Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C73F286C12
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Oct 2020 02:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgJHAbW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 20:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgJHAbW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 20:31:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFDEC061755
        for <linux-fscrypt@vger.kernel.org>; Wed,  7 Oct 2020 17:31:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q123so2550127pfb.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 07 Oct 2020 17:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uo0iV9T76AdXJrYK1sOUICbto9AV6/Gfz8QYpmAsbzA=;
        b=iuRJmTXMrEcCiTQJzRJ+xHPK/FIX/Smbxcz6lUEsLtQTqD1bylglJvZIKM6NWBBnCw
         gJBlfgpgBh2CvDZ2ewzog8oGkgvvgKciAdjoP2em5jX1h2Avt609vwyILJzh0H4yFzO3
         9LoseArWp1iwO8Z6Vh7Gb6/iaX3OnSh2r50HIsabeSmk9tXI/WwTiooIRll+M5WewLWG
         inrWzP0KMQvE0xxAuaeK9uBrVjkRDKauUOnQQQ7tW+i5cfslfeR9+xr5JLNKlFnFcHXn
         dAeiQJ2uI2E0JcAvgXMd/Vr9cwHczfeOftYqdoWSZ3mLWSHB+02EMjnYJNJ9AQ11krAo
         gaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uo0iV9T76AdXJrYK1sOUICbto9AV6/Gfz8QYpmAsbzA=;
        b=O0PN9NOPSERt8Eg6P+4ZGFqm5kiIC01y78ZOuYjHyH1wEPmMVpY/y+7ziANSmTFCsP
         5D0JxS9G3AgJj8uZX5bqL0/NYyuIiQYVG5CvSpxQWEcBSp+Cl167bCUmmAFOaxvsYmDy
         hSBU4D2Bc/EqkbeCdh3uElWW6rDMdLBM/KEVAxOyM5qobP3dR6kouWDLkFemlvEwmnbj
         DBlgMlnvjMzTKedtcwSmPfThIK9VTedYhoJdZd4CkvGOi9aAkJDtNBeThuelYj8hgnRR
         hPBUUAJACjoYFx9tgkxp8iwRllvBZIpid5umIpr12ROPbvzeEhEgNhP6FlfbrjUfxeW/
         5jqg==
X-Gm-Message-State: AOAM530NnDFHkm1vm4dO/2sIRmaIe7gYBdTiazn/byOONhWZg7X+2OLm
        VRFBAtZCqYw8Hs2ZuuIBjktOuw==
X-Google-Smtp-Source: ABdhPJwqoUNOA2OHE0VxNnVVVWX8tG0+JADgtjufctSYqlXuRglsK3npH1UDJ8p70IswpST9h5sqVw==
X-Received: by 2002:a17:90a:43:: with SMTP id 3mr5410408pjb.55.1602117080992;
        Wed, 07 Oct 2020 17:31:20 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id q4sm4380148pjl.28.2020.10.07.17.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 17:31:20 -0700 (PDT)
Date:   Thu, 8 Oct 2020 00:31:16 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/3] f2fs: Add metadata encryption support
Message-ID: <20201008003116.GA2556065@google.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <20201005073606.1949772-4-satyat@google.com>
 <20201007212052.GC1530638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007212052.GC1530638@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 07, 2020 at 02:20:52PM -0700, Eric Biggers wrote:
> On Mon, Oct 05, 2020 at 07:36:06AM +0000, Satya Tangirala wrote:
> > Wire up metadata encryption support with the fscrypt metadata crypt
> > additions.
> > 
> > Introduces a new mount option for metadata encryption -
> > metadata_crypt_key=%s. The argument to this option is the key descriptor of
> > the metadata encryption key in hex. 
> 
> It's unclear what "key descriptor in hex" means in this context.  Keys in the
> Linux keyrings subsystem can be specified either by an integer ID or by a string
> "description".
> 
> fscrypt_policy_v1 has an 8-byte binary master_key_descriptor, which specifies a
> keyring key with description "fscrypt:" + ToHex(master_key_descriptor).  So I'm
> guessing that's where this terminology is coming from.
> 
> However, here the value passed to metadata_crypt_key is just a key description
> that's passed directly to the Linux keyrings subsystem.  I don't see why it has
> to be a hex string (and it fact, it seems it's not enforced?).
Yeah, I really meant "string description". Also I'll be putting the
key identifier in the superblock so this mount option will be going
away.
> 
> The current proposal is also missing any sort of key verification.  The
> filesystem will use any key that is provided, even if a different key was used
> at format time.
>
I was relying on the validate_checkpoint() to fail when it tries to
verify the checkpoint checksum if an incorrect key is provided, but that
does sound bad to rely on from a design perspective. I'll do what you
mentioned below.
> In "fscrypt v2", we solved the equivalent problem by making the keys be
> specified by a HKDF-derived master_key_identifier.
> 
> How about doing something similar for the metadata encryption key?  I.e. the
> metadata encryption key could be used as input to HKDF to derive two subkeys:
> metadata_key_identifier and the real metadata encryption key.  Then
> metadata_key_identifier could be stored in the superblock.  Then the filesystem
> could request the keyring key "fscrypt:" + ToHex(metadata_key_identifier) at
> mount time, which would eliminate the need for a mount option.
> 
> > Direct I/O with metadata encryption is also not supported for now.
> > Attempts to do direct I/O on a metadata encrypted F2FS filesystem will fall
> > back to using buffered I/O (just as attempts to do direct I/O on fscrypt
> > encrypted files also fall back to buffered I/O).
> 
> What would it take to get direct I/O working?
> 
I think we'd first need to get the direct I/O with fscrypt via
blk-crypto patches in (i.e. the patch series at

https://lore.kernel.org/linux-fscrypt/20200724184501.1651378-1-satyat@google.com/
)

At least for single device filesystems, it shouldn't be much extra work to
support metadata encryption with the above patch in, especially once I make
fscrypt_set_bio_crypt_ctx() handle setting both the metadata encryption
and file encryption keys as you suggested in the previous patch - For
multi device filesystems, we'd need the offset of the block from the
start of the FS rather than offset of the block from the start of the
device that block belongs to (through my cursory glance at
dio_bio_alloc() where the above patch calls fscrypt_set_bio_crypt_ctx(),
I can see that the latter is readily available as first_sector, but I'm
not sure about the former - I'd imagine we can get that from the
dio->inode or something like that, or maybe some extra plumbing is
required).

> > +#ifdef CONFIG_FS_ENCRYPTION_METADATA
> > +	if (metadata_crypt_alg &&
> > +	    !fscrypt_metadata_crypted(sb)) {
> > +		f2fs_err(sbi, "Filesystem has metadata encryption. Please provide metadata encryption key to mount filesystem");
> > +		return -EINVAL;
> > +	}
> > +#endif
> 
> Please try to avoid #ifdefs.  It looks like some of these could be replaced with
> IS_ENABLED() or the use of stub functions.
> 
> - Eric
