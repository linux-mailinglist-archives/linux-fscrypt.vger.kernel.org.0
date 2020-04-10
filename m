Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C18A1A47BE
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Apr 2020 17:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDJPGK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Apr 2020 11:06:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46095 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726009AbgDJPGK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Apr 2020 11:06:10 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03AF646E026127
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 11:06:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 37A8942013D; Fri, 10 Apr 2020 11:06:04 -0400 (EDT)
Date:   Fri, 10 Apr 2020 11:06:04 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Message-ID: <20200410150604.GN45598@mit.edu>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
 <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
 <20200407053213.GC102437@sol.localdomain>
 <74B95427-9FB1-4DF8-BE75-CE099EA3A9A3@dilger.ca>
 <20200408031149.GA852@sol.localdomain>
 <AC4A8A20-E23D-4695-B127-65CBCD3A3209@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AC4A8A20-E23D-4695-B127-65CBCD3A3209@dilger.ca>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 10, 2020 at 05:53:54AM -0600, Andreas Dilger wrote:
> 
> Actually, I think the opposite is true here.  To avoid usability problems,
> users *have* to change the UUID of a cloned/snapshot filesystem to avoid
> problems with mount-by-UUID (e.g. either filesystem may be mounted randomly
> on each boot, depending on the device enumeration order).  However, if they
> try to change the UUID, that would immediately break all of the encrypted
> files in the filesystem, so that means with the stable_inode feature either:
> - a snapshot/clone of a filesystem may subtly break your system, or
> - you can't keep a snapshot/clone of such a filesystem on the same node

I don't think there is any reason why we would use IV_INO_LBLK_64 mode
on anything other than tablet/mobile devices using the latest UFS or
eMMC standards which support in-line crypto engines (ICE).  I'm not
aware of any cloud VM's, private or public, which supports ICE.  And
even if they did, hopefully they would use something more sane than
the UFS/eMMC spec, which only supports 64 bits of IV per I/O request,
and only support a small number of keys that can be loaded into the
hardware.  (This is what you get when you are optimizing Bill of
Materials costs down to a tenth of a cent; a million devices here,
retail store profit margins there, and before you know it you're
talking real money...)

Furthermore, on an modern x86_64, you can do AES encryption at less
than a cycle per CPU clock cycle, and in cloud VM's, battery life is
not a concern, so there really isn't any reason to use or implement
ICE, except maybe as a testing vehicle for fscrypt (e.g., someone
wanting to implement UFS 2.1 in qemu to make it easier to test the
Linux kernel's ICE support).

       	           	       	       	      	      - Ted
