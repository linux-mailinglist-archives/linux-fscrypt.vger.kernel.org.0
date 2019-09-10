Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E14AF36E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Sep 2019 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfIJXk7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Sep 2019 19:40:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35476 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJXk7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Sep 2019 19:40:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id s17so4398168plp.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Sep 2019 16:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=ffmjQlXS4yVy/vVVGz5kvYYh6Pjm4uvvcWpv2HOWjbY=;
        b=FU257zApd8KJO9oXKlxY+AVMU9jTscaSYcJLwwD6JRh7wY+4H2zbQAv08xt9TjExAu
         ML07G3mJFUt9yZzlJt0bzIxH7G2rOQOAVpQstwWv74VSI7ashZYLK15/OJahETqOHm6n
         wmNCEIxTUlve0xQu7LhVd1gHsYsxpczwX6MU+DWZbsJHMayuIXh2euIVrGEEtkG3+niJ
         Vr+Q7nlGFxekg2Bqw8kX3qF+7td3KC4RTiBKNHVSSGpI9ASml7WhYyfF5S2g/PRl0880
         uTXNiVIAqq6MIuBgxBJwQBY97wFq9WFK6q6KXFMgT0V9QU9uQjGQ6Ngyh3DYlrDDElOd
         aWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=ffmjQlXS4yVy/vVVGz5kvYYh6Pjm4uvvcWpv2HOWjbY=;
        b=VVIE1C5FGl9opLKf3oT2b9VbWRCa6Z6Zxix+VrySbpI2lqvZzRgTiylL6WzRPYuMFY
         e4jbP/TEyyJ6cUerpzo6CBhDoRlTyvZ7Dk4s3EWIykLbSTwL/kQRyZ8/HvE5kyWEe+v3
         P2E6hXcAxnpxPRIhCdI1ADQfSJWyo12FNBFSw1rN06/36vX4jPhGo4b4HedIEzCNdzYb
         CjGr2hQcKT60Lo7tIzRdGJTRzfmQHtnFoE/VDxs2xtB2GB6+hgdI1XV+hJYGX2w/58GY
         aMDK/XU1be02NPAWFUnp/ZUYH2lwh/4VeTskEuUiD+lpGy9wwuYKHOucz/OqXP2QyB9p
         ruyw==
X-Gm-Message-State: APjAAAVwCLgMGLWadYcVup75YllnIcJhJV8SqIWMrIaIXqSlFipflsZJ
        hfRah2nLiZiDpBOQKngAeJQPnVDXZDI=
X-Google-Smtp-Source: APXvYqymbIzBZLAk+98sEy7gd2SGa/llxmqDxirL0hGs2XRRKV1mJMwmTtK7J52LHgX5gFm+RP5YwQ==
X-Received: by 2002:a17:902:96a:: with SMTP id 97mr33861619plm.264.1568158856699;
        Tue, 10 Sep 2019 16:40:56 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id x22sm21507889pfi.139.2019.09.10.16.40.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 16:40:55 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <2757ADAC-336F-4EC8-8DBF-2B9C61C196C4@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_114FD3C9-E1AA-4A7A-B7A7-5FFDEC1AA31A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4] e2fsck: check for consistent encryption policies
Date:   Tue, 10 Sep 2019 17:40:51 -0600
In-Reply-To: <20190909174310.182019-1-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
References: <20190909174310.182019-1-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_114FD3C9-E1AA-4A7A-B7A7-5FFDEC1AA31A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 9, 2019, at 11:43 AM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> By design, the kernel enforces that all files in an encrypted =
directory
> use the same encryption policy as the directory.  It's not possible to
> violate this constraint using syscalls.  Lookups of files that violate
> this constraint also fail, in case the disk was manipulated.
>=20
> But this constraint can also be violated by accidental filesystem
> corruption.  E.g., a power cut when using ext4 without a journal might
> leave new files without the encryption bit and/or xattr.  Thus, it's
> important that e2fsck correct this condition.
>=20
> Therefore, this patch makes the following changes to e2fsck:
>=20
> - During pass 1 (inode table scan), create a map from inode number to
>  encryption policy for all encrypted inodes.  But it's optimized so
>  that the full xattrs aren't saved but rather only 32-bit "policy =
IDs",
>  since usually many inodes share the same encryption policy.  Also, if
>  an encryption xattr is missing, offer to clear the encrypt flag.  If
>  an encryption xattr is clearly corrupt, offer to clear the inode.
>=20
> - During pass 2 (directory structure check), use the map to verify =
that
>  all regular files, directories, and symlinks in encrypted directories
>  use the directory's encryption policy.  Offer to clear any directory
>  entries for which this isn't the case.
>=20
> Add a new test "f_bad_encryption" to test the new behavior.
>=20
> Due to the new checks, it was also necessary to update the existing =
test
> "f_short_encrypted_dirent" to add an encryption xattr to the test =
file,
> since it was missing one before, which is now considered invalid.
>=20
> Google-Bug-Id: 135138675
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks much better.  One minor nit below, but at this point you could =
add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> Changes v3 =3D> v4:
>=20
> - Save memory in common cases by storing ranges of inodes that share =
the
>  same encryption policy.
>=20
> - Rebased onto latest master branch.
>=20
>=20
> diff --git a/e2fsck/encrypted_files.c b/e2fsck/encrypted_files.c
> new file mode 100644
> index 00000000..3dc706a7
> --- /dev/null
> +++ b/e2fsck/encrypted_files.c
> @@ -0,0 +1,368 @@
>=20
> +/* A range of inodes which share the same encryption policy */
> +struct encrypted_file_range {
> +	ext2_ino_t		first_ino;
> +	ext2_ino_t		last_ino;
> +	__u32			policy_id;
> +};

This seems like a clear win...  As long as we have at least two inodes
in a row with the same policy ID it will take less space than the =
previous
version of the patch.

> +static int handle_nomem(e2fsck_t ctx, struct problem_context *pctx)
> +{
> +	fix_problem(ctx, PR_1_ALLOCATE_ENCRYPTED_DIRLIST, pctx);
> +	/* Should never get here */
> +	ctx->flags |=3D E2F_FLAG_ABORT;
> +	return 0;
> +}

It would be useful if the error message for =
PR_1_ALLOCATE_ENCRYPTED_DIRLIST
printed the actual allocation size that failed, so that the user has =
some
idea of how much memory would be needed.  The underlying =
ext2fs_resize_mem()
code doesn't print anything, just returns EXT2_ET_NO_MEMORY.

> +static int append_ino_and_policy_id(e2fsck_t ctx, struct =
problem_context *pctx,
> +				    ext2_ino_t ino, __u32 policy_id)
> +{
> +	struct encrypted_file_info *info =3D ctx->encrypted_files;
> +	struct encrypted_file_range *range;
> +
> +	/* See if we can just extend the last range. */
> +	if (info->file_ranges_count > 0) {
> +		range =3D &info->file_ranges[info->file_ranges_count - =
1];
> +
> +		if (ino <=3D range->last_ino) {
> +			/* Should never get here */
> +			fatal_error(ctx,
> +				    "Encrypted inodes processed out of =
order");
> +		}
> +
> +		if (ino =3D=3D range->last_ino + 1 &&
> +		    policy_id =3D=3D range->policy_id) {
> +			range->last_ino++;
> +			return 0;
> +		}
> +	}
> +	/* Nope, a new range is needed. */
> +
> +	if (info->file_ranges_count =3D=3D info->file_ranges_capacity) {
> +		/* Double the capacity by default. */
> +		size_t new_capacity =3D info->file_ranges_capacity * 2;
> +
> +		/* ... but go from 0 to 128 right away. */
> +		if (new_capacity < 128)
> +			new_capacity =3D 128;
> +
> +		/* We won't need more than the filesystem's inode count. =
*/
> +		if (new_capacity > ctx->fs->super->s_inodes_count)
> +			new_capacity =3D ctx->fs->super->s_inodes_count;
> +
> +		/* To be safe, ensure the capacity really increases. */
> +		if (new_capacity < info->file_ranges_capacity + 1)
> +			new_capacity =3D info->file_ranges_capacity + 1;

Not sure how this could happen (more inodes than s_inodes_count?), but
better safe than sorry I guess?

> +		if (ext2fs_resize_mem(info->file_ranges_capacity *
> +					sizeof(*range),
> +				      new_capacity * sizeof(*range),
> +				      &info->file_ranges) !=3D 0)
> +			return handle_nomem(ctx, pctx);

This is the only thing that gives me pause, potentially having a huge
allocation, but I think the RLE encoding of entries and the fact we
have overwhelmingly 64-bit CPUs means we could still run with swap
(on an internal NVMe M.2 device) if really needed.  A problem to fix
if it ever actually rears its head, so long as there is a decent error
message printed.

> +/*
> + * Find the ID of an inode's encryption policy, using the information =
saved
> + * earlier.
> + *
> + * If the inode is encrypted, returns the policy ID or
> + * UNRECOGNIZED_ENCRYPTION_POLICY.  Else, returns =
NO_ENCRYPTION_POLICY.
> + */
> +__u32 find_encryption_policy(e2fsck_t ctx, ext2_ino_t ino)
> +{
> +	const struct encrypted_file_info *info =3D ctx->encrypted_files;
> +	size_t l, r;
> +
> +	if (info =3D=3D NULL)
> +		return NO_ENCRYPTION_POLICY;
> +	l =3D 0;
> +	r =3D info->file_ranges_count;
> +	while (l < r) {
> +		size_t m =3D l + (r - l) / 2;

Using the RLE encoding for the entries should also speed up searching
here considerably.  In theory, for a single-user Android filesystem
there might only be one or two entries here.  It would be interesting
to run this on some of your filesystems to see what the average count
of inodes per entry is.

> +		const struct encrypted_file_range *range =3D
> +			&info->file_ranges[m];
> +
> +		if (ino < range->first_ino)
> +			r =3D m;
> +		else if (ino > range->last_ino)
> +			l =3D m + 1;
> +		else
> +			return range->policy_id;
> +	}
> +	return NO_ENCRYPTION_POLICY;
> +}


Cheers, Andreas






--Apple-Mail=_114FD3C9-E1AA-4A7A-B7A7-5FFDEC1AA31A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl14NIQACgkQcqXauRfM
H+CD1Q/+JXAI3V33yt2K5CDDJgcKT6hDDNazWlEeLRtJ7JDRx9tBMnvOFoVvSarX
uqk4/orBdxxSz+OJkcAnDzo6cmPBDnW70MVjOT6JA6CCdC97dH4GcBHJpVOR8v2E
etEM+g8+kJD7h8WU7veNjn4koyE4nlLgK8uRSUrRFEVzJth34+0S2UZ7G7wzpi5i
m00pNjyk9NT2oGzzxEH4BUbd/UALnkQ7SjybQbkS0J2vKtAqDPiyUWib2CvjVdL8
vCMyxUEfh4tj+6nBXlZiMUPq6taHAUdPHlV5Y7S4+Uraozrg8w24izlqMErSml/N
Bp027ROH4DsabGFsIOGguq1BUAAASFe+BXjGrSnWDdEg05gm8fbQZVkFszkROd91
cK9aXVS2d/7s1qRL0ro8UzNVYabDDW9umqKiA0yDH6+ZS1fEVVdnTxXj1urFH8AH
2EPwHYlAHCFv/SOHZKg2AK9ZmGQWttYTiOfGWA/te9zmWEtpFF5O/1FzLIvlMMZw
z4W/+c+BOplGoCzaPnTOBNcm0Iq2m5HzdKxTdujCDxYbrDA2tCG5GuJH/RXOdwhG
AcRnVZJtVCJaoXTjajQ/rWTCazqGaT8MD77W2tOtO4uxoi/2SfqdQ/BPsSggPXV3
DC02NJoCIKtwZRikeNF2ng3XegGaVnK4UAABX5X7jd/azFG7ETk=
=WrIv
-----END PGP SIGNATURE-----

--Apple-Mail=_114FD3C9-E1AA-4A7A-B7A7-5FFDEC1AA31A--
