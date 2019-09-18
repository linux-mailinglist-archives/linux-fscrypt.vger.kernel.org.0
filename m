Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D70B6F88
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Sep 2019 01:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfIRXGs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 Sep 2019 19:06:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39749 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbfIRXGr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 Sep 2019 19:06:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id x6so662946plv.6
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Sep 2019 16:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=2rcIoa3Qi8nbxa267M7FWbNBFFjAv0U3Z4xH/gFLz98=;
        b=Xj/puUE3F1IHN+drNjUWeCrOoFk3AFRKf6d4eKczp7IfkX+37hvV6bByeJDql6ctpC
         2ZNTzgY+5Ci9T0mra1Eh0sKlUEQyvKS4eBE2a3+RkaqOpPY1gnN7fARQB60vZg5ILbWB
         9/zYTo26u03BkDmzVkrNDhy4llx2JraPCA/rpRaQTxwpnHARfmj0YOg/jLZVL03d4oo9
         jddd9yv8BfS8fbjQlPnZH04d1gPMeOCp+lJ5c1pZ/fmm96YnYotEQTxHR+XmDhGhroP6
         xbKpKPucZE5M6P4Yl/8lUOETKEXTVmU29FlLEYdGDo4EXpexQKbLfqMHCo2k0GN0mOxk
         0+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=2rcIoa3Qi8nbxa267M7FWbNBFFjAv0U3Z4xH/gFLz98=;
        b=qvtY2WEe5eYSypf2P5OA5YYQ3YoiM1QXOxZ9QzfjDwmEdAhYS7uKahQH6om5gv9Ojd
         n8bzr1WotP1haCdWYmu/9gEfi1ouG1HKfOwaO4E2rBDkKhpF2R5U9289lSwuVh8FTZZZ
         awCd6XC5nN13tTjBo6PAUaq6zIB9eLwdfS0U94PNwZeQSQJm6+Noeg+5ozFaLDw0qJkY
         nyPcKNq1RPp2SIe1TjM5VzQTwlnPt3vDfNmo1rJuztiV2rAsiyAGofJ+oie1OMD2/rCc
         8HI1vTZOwSVZRWnFtpV1TZ31ew3Ntvx8IMhFbQ+ZB89DtAWuzVNIIWE9SfEncTO5EP95
         xpTg==
X-Gm-Message-State: APjAAAWtGx4bu5uRVDLywsanxUCUdzGVPDD8R3uv4KbjtWu+xNEw/kLi
        +/5BnYHhiInyW29qHlXWKBk2prTQPt8=
X-Google-Smtp-Source: APXvYqzg/otb2YmNvik+ooosCgw+xHvxztbgO6uYlMEIkWAq9za3eUQ6hGdO6pAtnhNCj/CL994W2w==
X-Received: by 2002:a17:902:8d98:: with SMTP id v24mr4643637plo.265.1568848005750;
        Wed, 18 Sep 2019 16:06:45 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id e6sm12844666pfl.146.2019.09.18.16.06.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 16:06:44 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <0EE70FDE-E6F8-4B5C-87CA-5ADC445B6848@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F8CF1AF7-DBCB-44DD-BDB2-343F86BCEA54";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v5] e2fsck: check for consistent encryption policies
Date:   Wed, 18 Sep 2019 17:06:43 -0600
In-Reply-To: <20190918010734.253049-1-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
References: <20190918010734.253049-1-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_F8CF1AF7-DBCB-44DD-BDB2-343F86BCEA54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Sep 17, 2019, at 7:07 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> 
> From: Eric Biggers <ebiggers@google.com>
> 
> By design, the kernel enforces that all files in an encrypted directory
> use the same encryption policy as the directory.  It's not possible to
> violate this constraint using syscalls.  Lookups of files that violate
> this constraint also fail, in case the disk was manipulated.
> 
> But this constraint can also be violated by accidental filesystem
> corruption.  E.g., a power cut when using ext4 without a journal might
> leave new files without the encryption bit and/or xattr.  Thus, it's
> important that e2fsck correct this condition.
> 
> Therefore, this patch makes the following changes to e2fsck:
> 
> - During pass 1 (inode table scan), create a map from inode number to
>  encryption policy for all encrypted inodes.  But it's optimized so
>  that the full xattrs aren't saved but rather only 32-bit "policy IDs",
>  since usually many inodes share the same encryption policy.  Also, if
>  an encryption xattr is missing, offer to clear the encrypt flag.  If
>  an encryption xattr is clearly corrupt, offer to clear the inode.
> 
> - During pass 2 (directory structure check), use the map to verify that
>  all regular files, directories, and symlinks in encrypted directories
>  use the directory's encryption policy.  Offer to clear any directory
>  entries for which this isn't the case.
> 
> Add a new test "f_bad_encryption" to test the new behavior.
> 
> Due to the new checks, it was also necessary to update the existing test
> "f_short_encrypted_dirent" to add an encryption xattr to the test file,
> since it was missing one before, which is now considered invalid.
> 
> Google-Bug-Id: 135138675
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>


Cheers, Andreas






--Apple-Mail=_F8CF1AF7-DBCB-44DD-BDB2-343F86BCEA54
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl2CuIMACgkQcqXauRfM
H+ArzhAAgvcV7rVD1sDS91a03F9/kjhtbG5hEHON8S296qTI7r1J4inIyUyG5ieC
nE4ws/rILNb4U/KiyWGC7kMngQ2/QF288BwKs+feJK5qTGolPyhIcf1kd4VgjM8b
6fnxgOfmj5+rhwE4s4VBsGQjB+N5AZfPTh2UubpZ61Auj8litpRxajc3Ml4DapPf
khsm99Dm6VxFJsWXW5IRTBOoPPPa6nR9kaTTvmWET34Pdf9znI52pA0oh0oBsTBx
0igOnjMNHQYWTJSXHDEuaTD6lIQzryiWhl0HNUDgd90YHlIV5Fh50l4L5sZEJZnV
PBPvgOqEvwcdL+9j61LOCn3rFB9Qy3uF4MYprle8V+q2dzKrOuYsFlCfNF3dmumZ
bVzG10MxM6BjlS4RL28LNrQX3+qSAVXssFXKYALovIQiBAH39oBTkBR1AbTzuJI4
f+5PkWYbp/LAnY5r1yJ4iGnTI0o60QJb76v6zWWGQNA//pi9Mw4iO7ZzzGpJkqgU
sY2RrRToAmFyCB7D0PBijgbSX8ACgYKHCRsGPhZUX27ur9PKbuOdI01LOQBDWCr4
nmSLTQthqR8N8Q1PC0p3vQYmt1pAppENY+VGc5OofHH63nnmYwU4PLHFOGnoDK3J
44xamn9rjyOwSFl5III2InXcqqFONl9BXS1XnRXF8hiQPpii3Sg=
=zUIG
-----END PGP SIGNATURE-----

--Apple-Mail=_F8CF1AF7-DBCB-44DD-BDB2-343F86BCEA54--
