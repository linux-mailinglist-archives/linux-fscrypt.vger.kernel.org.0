Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FA1A45F9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Apr 2020 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgDJLx7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Apr 2020 07:53:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41945 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgDJLx7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Apr 2020 07:53:59 -0400
Received: by mail-pf1-f194.google.com with SMTP id b8so959095pfp.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 10 Apr 2020 04:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=MDv3IRswB1ubQHfphZM18Iy2wZ2JeFLiaq/9ICnnnhk=;
        b=wETGEb/LuX47tB+fWQSf3JI4N8EtvZ62ylA9dJsUHbDcpPHmcJqER6c330rjRyiJsi
         9blKmhRdVYvA1HmUhgaJEQWPYtrzpzZsI4Y+lXU0yx3Q1GwpGL+mrY9OX0YbjS+JSHQZ
         E+e5rPzwZL7CAbtBhJceU5Wf7fwhFolWFaWcZ8kx5cBpA13xAWd9X5c+cwp51gc+R6aQ
         x7+A/GgOoHomIV0ggp+5nY3BgFGzsPtFmE6Qc982J7w+o0+S/KYre6hTChZjdQZtJfdR
         Etlvyim356bROtjDdrUEnrsq9AV9TRsCAhAfbMv/dnJc5te6Szok3eJp4MzXFAq/s8gf
         ZhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=MDv3IRswB1ubQHfphZM18Iy2wZ2JeFLiaq/9ICnnnhk=;
        b=HYaGQeWjbq6X97S3GGuytjvNSNMME5ZnIia+GruDs3LZDg17NsISs2IY9WUsy75OuV
         1tUPz6mPFRCArtjXXruRzP5dxep1gX0WVqhB0QpXhy6S+eQbUJHdUSB4Gmgq5lS70Jr0
         ArUprjixMBcM56rIbGbnB7GFRemlR9XRW3JXAHYllKy11R8IQFB8chzLULemmAiWOWyP
         tBrtEpO8696CI2nGnEDnwgmigMbbLyJM7UsegQ8XqgW4t2rxRsJs27EAQiR7Jy7tJmVU
         HUyHNT8Npz98LO8+zT4kBjPYXP6XmksKYsrmLR6am/Vy8brJq7ahFLaLAijifjmhzMzX
         W4wg==
X-Gm-Message-State: AGi0PuYAIsTI4ua1ontbAZHsDJNKsmpuMwDVCrH1u0nJfNgZYF3ZG2UU
        fZk1M4puARQhIKX/svmbeo4d2w==
X-Google-Smtp-Source: APiQypKQAl7pXOqgRPJo4bsPmBZQxOF3IRhs26FmbeMMrFdLu6kI4gLrdmWFx83iVWuU7ldAxjGhrg==
X-Received: by 2002:a62:3286:: with SMTP id y128mr3380811pfy.297.1586519638064;
        Fri, 10 Apr 2020 04:53:58 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id w127sm1590711pfb.70.2020.04.10.04.53.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 04:53:57 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <AC4A8A20-E23D-4695-B127-65CBCD3A3209@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8CACA77E-A7F4-4863-8F91-F5D83E6136FC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Date:   Fri, 10 Apr 2020 05:53:54 -0600
In-Reply-To: <20200408031149.GA852@sol.localdomain>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
 <20200407053213.GC102437@sol.localdomain>
 <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
 <20200408031149.GA852@sol.localdomain>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_8CACA77E-A7F4-4863-8F91-F5D83E6136FC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 7, 2020, at 9:11 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Tue, Apr 07, 2020 at 10:18:55AM -0600, Andreas Dilger wrote:
>>=20
>> One question though - for the data checksums it uses s_checksum_seed
>> to generate checksums, rather than directly using the UUID itself,
>> so that it *is* possible to change the filesystem UUID after
>> metadata_csum is in use, without the need to rewrite all of the
>> checksums in the filesystem.  Could the same be done for =
stable_inode?
>=20
> We could have used s_encrypt_pw_salt, but from a cryptographic =
perspective I
> feel a bit safer using the UUID.  ext4 metadata checksums are =
non-cryptographic
> and for integrity-only, so it's not disastrous if multiple filesystems =
share the
> same s_checksum_seed.  So EXT4_FEATURE_INCOMPAT_CSUM_SEED makes sense =
as a
> usability improvement for people doing things with filesystem cloning.
>=20
> The new inode-number based encryption is a bit different since it may =
(depending
> on how userspace chooses keys) depend on the per-filesystem ID for =
cryptographic
> purposes.  So it can be much more important that these IDs are really =
unique.
>=20
> On this basis, the UUID seems like a better choice since people doing =
things
> with filesystem cloning are more likely to remember to set up the =
UUIDs as
> unique, vs. some "second UUID" that's more hidden and would be =
forgotten about.

Actually, I think the opposite is true here.  To avoid usability =
problems,
users *have* to change the UUID of a cloned/snapshot filesystem to avoid
problems with mount-by-UUID (e.g. either filesystem may be mounted =
randomly
on each boot, depending on the device enumeration order).  However, if =
they
try to change the UUID, that would immediately break all of the =
encrypted
files in the filesystem, so that means with the stable_inode feature =
either:
- a snapshot/clone of a filesystem may subtly break your system, or
- you can't keep a snapshot/clone of such a filesystem on the same node

> Using s_encrypt_pw_salt would also have been a bit more complex, as =
we'd have
> had to add fscrypt_operations to retrieve it rather than just using =
s_uuid --
> remembering to generate it if unset (mke2fs doesn't set it).  We'd =
also have
> wanted to rename it to something else like s_encrypt_uuid to avoid =
confusion as
> it would no longer be just a password salt.
>=20
> Anyway, we couldn't really change this now even if we wanted to, since
> IV_INO_LBLK_64 encryption policies were already released in v5.5.

I'm not sure I buy these arguments...  We changed handling of =
metadata_csum
after the fact, by checking at mount if s_checksum_seed is initialized,
otherwise hashing s_uuid and storing if it is zero.  Storing =
s_checksum_seed
proactively in the kernel and e2fsck allows users to change s_uuid if =
they
have a new enough kernel without noticing that the checksums were =
originally
based on s_uuid rather than the hash of it in s_checksum_seed.

I'm not sure of the details of whether s_encrypt_pw_salt is used in the
IV_INO_LBLK_64 case or not (since it uses inode/block number as the =
salt?),
but I see that the code is already initializing s_encrypt_pw_salt in the
kernel if unset, so that is not hard to do.  It could just make a copy =
from
s_uuid rather than generating a new UUID for s_encrypt_pw_salt, or for =
new
filesystems it can generate a unique s_encrypt_pw_salt and only use =
that?

Storing a feature flag to indicate whether s_uuid or s_encrypt_pw_salt =
is
used for the IV_INO_LBLK_64 case seems pretty straight forward?  Maybe =
any
filesystems that are using IV_INO_LBLK_64 with s_uuid can't change the =
UUID,
but a few bits and lines of code could allow any new filesystem to do =
so?
If you consider that 5.5 has been out for a few months, there aren't =
going
to be a lot of users of that approach, vs. the next 10 years or more.

In the end, you are the guy who has to deal with issues here, so I leave =
it
to you.  I just think it is a problem waiting to happen, and preventing =
the
users from shooting themselves in the foot with tune2fs doesn't mean =
that
they won't have significant problems later that could easily be solved =
now.

Cheers, Andreas






--Apple-Mail=_8CACA77E-A7F4-4863-8F91-F5D83E6136FC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl6QXlMACgkQcqXauRfM
H+A2/BAAj3A+xV/bbMjf6Suyp3Qait7am1miMOs98ReoR6RD5IkqDr+H5JQATx+a
CpM8kFngM7vH7O1tH/RDUkE+0kdjKIqGCOW9G1lFXQbvUCFUTt72CvtN0+D0HcED
Wv81H2IBvdTB+0dWiULRs+GqjEEYeMXL5BeEd1qlSnieJl0kME9ILcXPS3TN0N98
yeGMP985AB3ec1C7JZcz0oOYRq4QZqXHea4vgWpRpHZfusLm/EyFuXp4d497YYNp
9wdl6sWq42+0rVROeGh4ZXd8pSOodEmmwRZXzz+Zr3tILgfYtkz4tPrCmusPPnHm
Cy9aEVpSZVTNiT7PAyeGQC3T3blBmbQhx7OuOiHwboaEBWdaMiWaNRe9syxrvGVW
ZsbMWAuTQuX/9Uv21/ZTqtinu1eqtvtxsi7Qu0r1mMLrgVNByloJkuolVW8sK6vc
M89z0+TFQf8NlWdNC1/qhdCY7FTPuzAuRCzyA1zoCuyGDMGVS5PhRdDKQRVvSkdw
LWQhvkPOXHKFTJPvdISEX85EsIKBEO0Fm5pruW9SrnX81dieDJWWUnI87O5+iRpH
NQ3kdsJNF5dbC3bhCsPjRc8+a6K1aN5t9tAxklwgaJG5HqJSahmbMb1zAbZL1jYY
ZgtwpSzhnwej37b+7iBjSk90RdoYwIDDVlSb14Hk4DU2UWC14/E=
=9z1J
-----END PGP SIGNATURE-----

--Apple-Mail=_8CACA77E-A7F4-4863-8F91-F5D83E6136FC--
