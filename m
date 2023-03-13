Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9526B7F0A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 18:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCMRNq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCMRNd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 13:13:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5426C8698;
        Mon, 13 Mar 2023 10:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 848FAB811B2;
        Mon, 13 Mar 2023 17:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E2FC43443;
        Mon, 13 Mar 2023 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678727520;
        bh=evjksweuySXgB4DScaJo8MCH4+Y8CDvl7iHHX6kfrZg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dwvFahGLtRm1zbdrEs7N/sqNgcd1edz1J5baI6XvubBA5KVbHenKWPmdsogqnAcJ6
         JHUaeB0c3oVC3yqZFsadXF4+El5Z+Wf/Sta+4q5NOWYfb/fZ0gp9ArmZ8Vjep3jx9/
         MaNDJzgJ5W/qxdj8wFY66DCuz3DEnbIrrsPglQpGUWaLK+VDrR8ZXHoq7qo+EzuTHs
         6/qMIEEQHqvNHb0ZVHKe7EyLeQsJ6pasOLr0CsuzT/SsvZ7kE3hCNBpbFGfk3uein4
         SL6u5b0GHFvuuKugpC50DqmeOz8Eow9JwgP2sszFifGCRLOTJmI5nfoZP7u2U12r2m
         XVXUyAyO7k9vw==
Message-ID: <6a7591c133208a11b24169ed74124dca3c11c7fe.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: fscrypt: fix atomic open bug for encrypted
 directories
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 13 Mar 2023 13:11:57 -0400
In-Reply-To: <20230313123310.13040-1-lhenriques@suse.de>
References: <20230313123310.13040-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2023-03-13 at 12:33 +0000, Lu=EDs Henriques wrote:
> Hi!
>=20
> I started seeing fstest generic/123 failing in ceph fscrypt, when running=
 it
> with 'test_dummy_encryption'.  This test is quite simple:
>=20
> 1. Creates a directory with write permissions for root only
> 2. Writes into a file in that directory
> 3. Uses 'su' to try to modify that file as a different user, and
>    gets -EPERM
>=20
> All the test steps succeed, but the test fails to cleanup: 'rm -rf <dir>'
> will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat() to rem=
ove
> the file got a -ENOENT and then -ENOTEMPTY for the directory.
>=20
> This is because 'su' does a drop_caches ('su (874): drop_caches: 2' in
> dmesg), and ceph's atomic open will do:
>=20
> 	if (IS_ENCRYPTED(dir)) {
> 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> 		if (!fscrypt_has_encryption_key(dir)) {
> 			spin_lock(&dentry->d_lock);
> 			dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> 			spin_unlock(&dentry->d_lock);
> 		}
> 	}
>=20
> Although 'dir' has the encryption key available, fscrypt_has_encryption_k=
ey()
> will return 'false' because fscrypt info isn't yet set after the cache
> cleanup.
>=20
> The first patch will add a new helper for the atomic_open that will force
> the fscrypt info to be loaded into an inode that has been evicted recentl=
y
> but for which the key is still available.
>=20
> The second patch switches ceph atomic_open to use the new fscrypt helper.
>=20
> Cheers,
> --
> Lu=EDs
>=20
> Changes since initial RFC (after Eric's review):
> - Added kerneldoc comments to the new fscrypt helper
> - Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
> - Added IS_ENCRYPTED() check in helper
> - DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() returns a=
n
>   error
> - Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inline')
>=20
> Lu=EDs Henriques (2):
>   fscrypt: new helper function - fscrypt_prepare_atomic_open()
>   ceph: switch atomic open to use new fscrypt helper
>=20
>  fs/ceph/file.c          |  8 +++-----
>  fs/crypto/hooks.c       | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/fscrypt.h |  7 +++++++
>  3 files changed, 45 insertions(+), 5 deletions(-)
>=20

Looks like a nice cleanup.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
