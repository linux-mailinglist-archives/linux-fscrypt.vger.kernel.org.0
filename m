Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FCE651C0A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Dec 2022 09:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiLTIAx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 20 Dec 2022 03:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiLTIAu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 20 Dec 2022 03:00:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A5D39D;
        Tue, 20 Dec 2022 00:00:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C58FB810F6;
        Tue, 20 Dec 2022 08:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4696C433D2;
        Tue, 20 Dec 2022 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671523239;
        bh=qKrYmmUsHjJe687RNXG5tlMw6zNh6SnNwGDdKHHnQtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JHutIuIRzyeK2/5+O+DBx7fE+QkBwuo6WNGdiJsUxZEl291QxYSuZQ0EXMYV+QH9H
         0+KrfUf0yQxTtPMfgrC3DFb0ZfpD5H9uJWX/kyUzUYKAP81IhnWWjlpJYi5lVJG8V4
         2PeM1oDFFwgumsQJ1I12OJll+ByQjTUONcq93uzyK4Oszns+kMim/ZQgYhwaXsJ8FN
         z3+5OI9eUOgw08hUjsFuC5SPrE1Zp4vzZGOcl0hutHLbq5Lk/uuKInboWBpQHZnVhZ
         kmxAVQ+lYV4G6sRDJraiUIdN2RpyxS3yMoGFKKmHvanz2hhtOUpo9YB7L0HFOzIaCC
         IlU0FtRSHjBlA==
Date:   Tue, 20 Dec 2022 00:00:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 09/10] generic/624: test multiple Merkle tree block sizes
Message-ID: <Y6FrpRypj1/oFND9@sol.localdomain>
References: <20221211070704.341481-1-ebiggers@kernel.org>
 <20221211070704.341481-10-ebiggers@kernel.org>
 <20221220065604.eorvm6nlzamh6tyt@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220065604.eorvm6nlzamh6tyt@zlang-mailbox>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 20, 2022 at 02:56:04PM +0800, Zorro Lang wrote:
> > +# Always test FSV_BLOCK_SIZE.  Also test some other block sizes if they happen
> > +# to be supported.
> > +_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=FSV_BLOCK_SIZE"
> > +test_block_size $FSV_BLOCK_SIZE
> > +for block_size in 1024 4096 16384 65536; do
> > +	_fsv_scratch_begin_subtest "Testing FS_IOC_READ_VERITY_METADATA with block_size=$block_size"
> > +	if (( block_size == FSV_BLOCK_SIZE )); then
> > +		continue
> > +	fi
> > +	if ! _fsv_can_enable $fsv_file --block-size=$block_size; then
> > +		echo "block_size=$block_size is unsupported" >> $seqres.full
> > +		continue
> 
> If a block size isn't supported, e.g. 1024. Then this case trys to skip that
> test, but it'll break golden image, due to the .out file contains each line
> of:
>   Testing FS_IOC_READ_VERITY_METADATA with block_size=1024/4096/16384/65536
> 
> Do you expect that failure, or we shouldn't fail on that?

Actually it doesn't fail, since "Testing FS_IOC_READ_VERITY_METADATA with
block_size=$block_size" is printed unconditionally, and
"block_size=$block_size is unsupported" is only printed to $seqres.full.

To avoid this confusion, how about I change "Testing FS_IOC_READ_VERITY_METADATA
with block_size=$block_size" to "Testing block_size=$block_size if supported"?
Or do you have another suggestion?

- Eric
