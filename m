Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F576871DD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Feb 2023 00:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjBAX0k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Feb 2023 18:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBAX0k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Feb 2023 18:26:40 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABB1A10E8;
        Wed,  1 Feb 2023 15:26:39 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 6288E20B7102; Wed,  1 Feb 2023 15:26:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6288E20B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675293999;
        bh=BX5vYqzCUuxBDhWDfQG+i4l5HC6duxNMf1A8F9utGsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ObNoaB606rE1/dxhUr21FdCxl9YLwN6dJIHFoJKrSkNCMotvzhTwTiKjOlc4x6ddf
         mya4GY8c/KVQJ1Ht+q3y/fpT3Tr1q2ww5jT2vidqUuHljLIMTWHQ9rGbEzwZbC9GrH
         nfzEYKS5IN3w9uoEDlFv+HmmzCZxXXZo9fTsGP8U=
Date:   Wed, 1 Feb 2023 15:26:39 -0800
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
Message-ID: <20230201232639.GB9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
 <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
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

On Tue, Jan 31, 2023 at 02:22:01PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > dm-verity provides a strong guarantee of a block device's integrity. As
> > a generic way to check the integrity of a block device, it provides
> > those integrity guarantees to its higher layers, including the filesystem
> > level.
> 
> I think you could reuse most of is_trusted_verity_target(), in
> particular dm_verity_get_root_digest().
> 
> And probably, the previous patch is not necessary.
> 
> Roberto
> 
Thanks for the info. This function seems could be used to get the roothash
but for saving the signature we still need the hook function in the previous
patch.

-Fan
