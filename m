Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911468E49E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Feb 2023 00:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBGXwr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Feb 2023 18:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBGXwq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Feb 2023 18:52:46 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD5022DE56;
        Tue,  7 Feb 2023 15:52:43 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 176D020C7E3B; Tue,  7 Feb 2023 15:52:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 176D020C7E3B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675813963;
        bh=bN+LfT2jCsmdfpuG53FeQKLA8B080GGv4HrkY+14DXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSfonHypMPNXA/gQOAT23RUpooup3G7+qibjblfPVtx6A1CKJWe3gizG59dykFgCp
         YZqOCVC1arTMI5pL3NStHy3tE1QO8YQMlWNJGnDgL355x/w6sgpO0tkgu8YIRLPlzi
         yoxiJL98QkkTB+6GGAMiog/8Qevkz8CRvtEUpSI0=
Date:   Tue, 7 Feb 2023 15:52:43 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 10/16] dm-verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <20230207235243.GA5107@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
 <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
 <20230201232639.GB9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <903062f7b2e2709ae0e4416545ffadd91c132676.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903062f7b2e2709ae0e4416545ffadd91c132676.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Feb 02, 2023 at 09:21:24AM +0100, Roberto Sassu wrote:
> On Wed, 2023-02-01 at 15:26 -0800, Fan Wu wrote:
> > On Tue, Jan 31, 2023 at 02:22:01PM +0100, Roberto Sassu wrote:
> > > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > > 
> > > > dm-verity provides a strong guarantee of a block device's integrity. As
> > > > a generic way to check the integrity of a block device, it provides
> > > > those integrity guarantees to its higher layers, including the filesystem
> > > > level.
> > > 
> > > I think you could reuse most of is_trusted_verity_target(), in
> > > particular dm_verity_get_root_digest().
> > > 
> > > And probably, the previous patch is not necessary.
> > > 
> > > Roberto
> > > 
> > Thanks for the info. This function seems could be used to get the roothash
> > but for saving the signature we still need the hook function in the previous
> > patch.
> 
> Uhm, look at the LoadPin case. It does not need to temporarily store
> the root digest in a security blob. It evaluates it directly.
> 
> Well, ok, dm_verity_loadpin_is_bdev_trusted() looks for trusted digests
> in the dm_verity_loadpin_trusted_root_digests list. So, something
> equivalent needs to be made for IPE (or you just get the digest).
> However, I find not introducing new hooks and evaluating the
> information directly more efficient.
> 
> Roberto

Thanks for the input. I did a deeper dive into the source code and did some
experiements, my conclusion is the hook is still the preferred way for us.

For the root digest part, dm_verity_loadpin_is_bdev_trusted is able to query
the root digest is because the root digest is saved in struct dm_verity.
Specifically it will call dm_verity_get_root_digest to kmemdup the digest.
If every binary execution will trigger a kmemdup to copy a digest,
the overhead will be noticeable. 
Using a hook can let us copy the root digest exactly once when
the block device is created and free the copied digest when 
the block device is unmounted. 

For the signature, it is currently an optional parameter and it is not
saved in struct dm_verity. But even if we let struct dm_verity saves
the signature it will still have the kmemdup problem above. 
So using the hook will be the cleanest way.

-Fan
