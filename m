Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16924C21AE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 03:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiBXCR0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Feb 2022 21:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiBXCRZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Feb 2022 21:17:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC304CD71;
        Wed, 23 Feb 2022 18:16:55 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21O01Rop005376;
        Thu, 24 Feb 2022 01:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=hxIe060VY8iAwZUhENZ7/n+sdp6TZCXyeb3v4M2Wzfg=;
 b=NH513txvmsg4gVHgZaJlJH0ksW5KqciXUN63BzU7ske5qgbUeEVLuANZJ8+ImdkvwQEg
 zzWeiy4cAV2innTnS77DiPJTZSmfOAHPptTRiAxhiTbWWsHNp+SmgHsep8Y9bkiBhdOy
 mR6qpX7Wncw/M9knjNM3udpn4Wu1cjqWJ+0SB/oIO8uX8gbweWcid0JXnSBHElHmzEZa
 mOWRgjQjnUt8q8N0x2b425ODO/1HnRazcxk8M+zZS1UxTKj7+ixjYyg8aY7zynGmaqIs
 zT/16r8nlwlS2BgYVgLpAoqKJsd2K2lAqRwH7SKVmjLifRZrZnyH3JWkiaSJEKSV9nKh lA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edsjt0nx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 01:27:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21O18eAU011477;
        Thu, 24 Feb 2022 01:27:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtjdq42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 01:27:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21O1RoF741746892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 01:27:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4842DA4054;
        Thu, 24 Feb 2022 01:27:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F57A405C;
        Thu, 24 Feb 2022 01:27:49 +0000 (GMT)
Received: from sig-9-65-80-154.ibm.com (unknown [9.65.80.154])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 01:27:49 +0000 (GMT)
Message-ID: <c6d3fcf09a56ad3b3fcc011b7fd3b8207675ad8e.camel@linux.ibm.com>
Subject: Re: [PATCH v5 3/8] fs-verity: define a function to return the
 integrity protected file digest
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Feb 2022 20:27:49 -0500
In-Reply-To: <YhbeuQpGuDxEmi9o@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-4-zohar@linux.ibm.com>
         <YhbKYZcWxmi4auJU@sol.localdomain>
         <f322ae351dde71b92d7d4037d78190c7338ca710.camel@linux.ibm.com>
         <YhbeuQpGuDxEmi9o@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8Vdu6TyC8Uy-pK-MXoUpXs2me1Aohccl
X-Proofpoint-GUID: 8Vdu6TyC8Uy-pK-MXoUpXs2me1Aohccl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240002
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2022-02-23 at 17:26 -0800, Eric Biggers wrote:
> On Wed, Feb 23, 2022 at 08:21:01PM -0500, Mimi Zohar wrote:
> > On Wed, 2022-02-23 at 15:59 -0800, Eric Biggers wrote:
> > > On Fri, Feb 11, 2022 at 04:43:05PM -0500, Mimi Zohar wrote:
> > > > +/**
> > > > + * fsverity_get_digest() - get a verity file's digest
> > > > + * @inode: inode to get digest of
> > > > + * @digest: (out) pointer to the digest
> > > > + * @alg: (out) pointer to the hash algorithm enumeration
> > > > + *
> > > > + * Return the file hash algorithm and digest of an fsverity protected file.
> > > > + *
> > > > + * Return: 0 on success, -errno on failure
> > > > + */
> > > > +int fsverity_get_digest(struct inode *inode,
> > > > +			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> > > > +			enum hash_algo *alg)
> > > > +{
> > > > +	const struct fsverity_info *vi;
> > > > +	const struct fsverity_hash_alg *hash_alg;
> > > > +	int i;
> > > > +
> > > > +	vi = fsverity_get_info(inode);
> > > > +	if (!vi)
> > > > +		return -ENODATA; /* not a verity file */
> > > 
> > > Sorry for the slow reviews; I'm taking a look again now.  One question about
> > > something I missed earlier: is the file guaranteed to have been opened before
> > > this is called?  fsverity_get_info() only returns a non-NULL value if the file
> > > has been opened at least once since the inode has been loaded into memory.  If
> > > the inode has just been loaded into memory without being opened, for example due
> > > to a call to stat(), then fsverity_get_info() will return NULL.
> > > 
> > > If the file is guaranteed to have been opened, then the code is fine, but the
> > > comment for fsverity_get_digest() perhaps should be updated to mention this
> > > assumption, given that it takes a struct inode rather than a struct file.
> > > 
> > > If the file is *not* guaranteed to have been opened, then it would be necessary
> > > to make fsverity_get_digest() call ensure_verity_info() to set up the
> > > fsverity_info.
> > 
> > Yes, fsverity_get_digest() is called as a result of a syscall - open,
> > execve, mmap, etc.   
> > Refer to the LSM hooks security_bprm_check() and security_mmap_file().
> > ima_file_check() is called directly in do_open().
> 
> stat() is a syscall too, so the question is not whether this is being called as
> a result of a syscall, but rather whether it's only being called while the file
> is open (or at least previously opened).  Is the answer to that "yes"?

yes

