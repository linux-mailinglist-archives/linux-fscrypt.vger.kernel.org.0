Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EE46BBAA5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 18:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjCORNH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 13:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjCORNF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 13:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E4187A1B;
        Wed, 15 Mar 2023 10:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B697061E0B;
        Wed, 15 Mar 2023 17:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D5EC433D2;
        Wed, 15 Mar 2023 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678900371;
        bh=3KNXp+YAw4NtyGfB9kXNMdujQy5tK9O490wMJB0UPBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ngo9cjShnebdiQkn1zwjlTUpolJv630iEoESOvJuN/UfeYBVKva3u+woh8oIKk7Mc
         ofhvfoM8BvqfXpGLzJNUgS1+gxVKqiGBn5yOA0B9Xb7hmz8c9/wK1yYY7maSmNu3oY
         aA+NaMGNmtu7M3keDu60Ih6TUfliEUN8i9wpZR3EGFv5f5ogN9e3cTPgkSba2jGnGf
         bX+y6znPR5fuojBrQ/8AESQg1nB8bbV0HetgjSWnI2avOpj2zHkELiHfTvfaHwLOEH
         iTv2vKnH1CXKZkNeF7mSpAFq3PuHBUi6dvdGiTc0+X/klclbTFoZepnWfE0IEx1UCv
         XljYDStKR7EMQ==
Date:   Wed, 15 Mar 2023 10:12:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Message-ID: <20230315171249.GA975@sol.localdomain>
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
 <ZA9mwPUg7H/fq0L8@sol.localdomain>
 <87zg8ftz9s.fsf@suse.de>
 <ZBC1P4Gn6eAKD61+@sol.localdomain>
 <87pm9atgpk.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pm9atgpk.fsf@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 15, 2023 at 11:08:23AM +0000, Luís Henriques wrote:
> > So, actually I think this patch doesn't make sense.  If ceph is doing the above
> > in its ->lookup() anyway, then it just should do the exact same thing in its
> > ->atomic_open() too.
> 
> In fact, my initial fix for the cephfs bug was doing just that.  It was a
> single patch to ceph_atomic_open() that would simply do:
> 
> 	if (IS_ENCRYPTED(dir)) {
> 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> 		err = __fscrypt_prepare_readdir(dir);
> 		if (!err && !fscrypt_has_encryption_key(dir)) {
> 			spin_lock(&dentry->d_lock);
> 			dentry->d_flags |= DCACHE_NOKEY_NAME;
> 			spin_unlock(&dentry->d_lock);
> 		}
> 	}
> 
> What made me want to create a new helper was that I simply needed to call
> fscrypt_get_encryption_info() to force the encryption info to be set in
> the parent directory.  But this function was only accessible through
> __fscrypt_prepare_readdir(), which isn't really a great function name for
> what I need here.
> 
> Since __fscrypt_prepare_readdir() doesn't seem to be used anywhere else,
> maybe it could be removed and fscrypt_get_encryption_info() be exported
> instead?

Well, fscrypt_get_encryption_info() *used* to be exported, but it was hard to
keep track of its use cases (some of which were not actually necessary), which
is why it eventually got replaced with use-case oriented helper functions.

Maybe just use fscrypt_prepare_lookup_partial() for the name of your new helper
function (instead of fscrypt_prepare_atomic_open())?

- Eric
