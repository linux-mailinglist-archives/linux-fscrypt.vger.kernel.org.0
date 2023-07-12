Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C8174FDED
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jul 2023 05:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjGLDng (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jul 2023 23:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjGLDna (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jul 2023 23:43:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75246198B;
        Tue, 11 Jul 2023 20:43:20 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id D850A21C4255; Tue, 11 Jul 2023 20:43:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D850A21C4255
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689133399;
        bh=AQSDwVr//PWnanNDVqJOKnFjTzDXsVxMzaz8VzfLX9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gd86CwrooCUzTzLtcrbfpPja1MDbDSHeRi2drRdRHQKEr7+MeHUdPmo1OYofl8LO5
         /BxTBXcBx+61KNVGQwmn84+RCmceckkYRqDvUCBubBwyfYCe0o4LvKZoEff8AP92wV
         PLwJXBucI4r1Hv+6Ky15fLjo3Ox/F0xK3pPqj7RM=
Date:   Tue, 11 Jul 2023 20:43:19 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
        paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v10 11/17] dm-verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKgm+ffQbdDTxrg9@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 07, 2023 at 10:53:45AM -0400, Mike Snitzer wrote:
Thanks for the review!

> On Wed, Jun 28 2023 at  5:09P -0400,
> Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > dm-verity provides a strong guarantee of a block device's integrity. As
> > a generic way to check the integrity of a block device, it provides
> > those integrity guarantees to its higher layers, including the filesystem
> > level.
> > 
> > An LSM that control access to a resource on the system based on the
> > available integrity claims can use this transitive property of
> > dm-verity, by querying the underlying block_device of a particular
> > file.
> > 
> > The digest and signature information need to be stored in the block
> > device to fulfill the next requirement of authorization via LSM policy.
> > This will enable the LSM to perform revocation of devices that are still
> > mounted, prohibiting execution of files that are no longer authorized
> > by the LSM in question.
> > 
> > This patch added two security hook calls in dm-verity to save the
> > dm-verity roothash and the roothash signature to LSM blobs.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
...
> > diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> > index 4836508ea50c..33165dd7470f 100644
> > --- a/drivers/md/dm-verity-verify-sig.c
> > +++ b/drivers/md/dm-verity-verify-sig.c
> > @@ -9,6 +9,9 @@
> >  #include <linux/verification.h>
> >  #include <keys/user-type.h>
> >  #include <linux/module.h>
> > +#include <linux/security.h>
> > +#include <linux/dm-verity.h>
> > +#include "dm-core.h"
> 
> Why are you including dm-core.h here?
This is used to get the complete definition of struct mapped_device to extract
the struct block_device from it.

> 
> >  #include "dm-verity.h"
> >  #include "dm-verity-verify-sig.h"
> >  
> > @@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
> >   * verify_verify_roothash - Verify the root hash of the verity hash device
> >   *			     using builtin trusted keys.
> >   *
> > + * @bdev: block_device representing the device-mapper created block device.
> > + *	  Used by the security hook, to set information about the block_device.
> >   * @root_hash: For verity, the roothash/data to be verified.
> >   * @root_hash_len: Size of the roothash/data to be verified.
> >   * @sig_data: The trusted signature that verifies the roothash/data.
> >   * @sig_len: Size of the signature.
> >   *
> >   */
> > -int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> > -			    const void *sig_data, size_t sig_len)
> > +int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
> > +			    size_t root_hash_len, const void *sig_data,
> > +			    size_t sig_len)
> >  {
> >  	int ret;
> >  
> > @@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> >  				NULL,
> >  #endif
> >  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> > +	if (ret)
> > +		return ret;
> >  
> > -	return ret;
> > +	return security_bdev_setsecurity(bdev,
> > +					 DM_VERITY_SIGNATURE_SEC_NAME,
> > +					 sig_data, sig_len);
> >  }
> >  
> >  void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
> 
> Both of your calls to security_bdev_setsecurity() to set your blobs in
> the bdev are suspect because you're doing so from the verity_ctr().
> The mapped_device has 2 dm_table slots (active and inactive).  The
> verity_ctr() becomes part of the inactive slot, there is an extra step
> to bind the inactive table to the active table.
> 
> This leads to you changing the blobs in the global bdev _before_ the
> table is actually active.  It is possible that the inactive table will
> simply be removed and the DM verity device put back in service;
> leaving your blob(s) in the bdev inconsistent.
> 
> This issue has parallels to how we need to defer changing the global
> queue_limits associated with a request_queue until _after_ all table
> loading is settled and then the update is done just before resuming
> the DM device (mapped_device) -- see dm_table_set_restrictions().
> 
> Unfortunately, this feels like it may require a new hook in the
> target_type struct (e.g. ->finalize())
> 
> Mike
Thanks for pointing out this issue. We were calling security_bdev_setsecurity()
because the roothash signature data is only available in verity_ctr()
and it is discarded after verity_ctr() finishes.
After digging deeper into the table_load, I realized that we were indeed
wrong here.

Based on my understanding of your suggestion, it seems that the correct
approach would be to save the roothash signature into the struct dm_target
and then invoke security_bdev_setsecurity() before activating
the inactive table in the __bind function (where dm_table_set_restrictions is called).

To facilitate this process, it seems appropriate to introduce a new hook
called finalize() within the struct target_type. This hook would enable
targets to define tasks that need to be completed before activating
a new table.

In our specific case, we would add a finalize hook to the dm-verity module,
allowing us to call security_bdev_setsecurity() and associate the roothash
information in the struct dm_target with the struct block_device of
the struct mapped_device. Is this correct?

Thanks,
- Fan

