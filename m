Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC4C1A47D2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Apr 2020 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgDJPYS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Apr 2020 11:24:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49040 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbgDJPYS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Apr 2020 11:24:18 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03AFO7Cl032221
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 11:24:07 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D7A0A42013D; Fri, 10 Apr 2020 11:24:06 -0400 (EDT)
Date:   Fri, 10 Apr 2020 11:24:06 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200410152406.GO45598@mit.edu>
References: <20200401203239.163679-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401203239.163679-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> (which can exist if the stable_inodes feature is set) could be broken:
> 
> - Changing the filesystem's UUID
> - Clearing the stable_inodes feature
> 
> Also document the stable_inodes feature in the appropriate places.
> 
> Eric Biggers (4):
>   tune2fs: prevent changing UUID of fs with stable_inodes feature
>   tune2fs: prevent stable_inodes feature from being cleared
>   ext4.5: document the stable_inodes feature
>   tune2fs.8: document the stable_inodes feature

Thanks, I've applied this patch series.

						- Ted
