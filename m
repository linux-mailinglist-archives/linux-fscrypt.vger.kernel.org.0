Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063AF4DCA4F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 16:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiCQPs3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiCQPrt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 11:47:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAFF20DB32;
        Thu, 17 Mar 2022 08:46:32 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HFhsug030743;
        Thu, 17 Mar 2022 15:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=C/BmYCQkeBQKlE5Lu/YXDuV3yfbU86aKQwCpLY+QaJg=;
 b=OlqV2qKkfGMQ3pxrIserl4kCdB0hshcnPBN2WFeXMDcKXrfFXHbJi7MpANZizxh4tN+E
 mNGmVk2daELUFCNiV28HDXi0HlDBUhNXgAfn/80g1SSKy/EVHLMBiboOQKVv8O0pmDxs
 GnKHh0zvGkWQqq+c1JkO8FXBKmGPPTvcebbjma8/ZhBYKi/oMcjxkTmUIfkp5o8tLk9G
 4QMpm9zuVZ4m94N9ELQOdvQXAm6mHcz7GFAbyrGfPenslReGAH5vG43+AVKzUSMfD10U
 t9MFJITqbRH79nfSSFCmLtXwChQvD5MRB5b1Y5ZPRc3Yds+cy5+Jb85wiTahzBer51B3 vg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev2sbpx9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 15:46:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22HFYfJq003075;
        Thu, 17 Mar 2022 15:46:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3erk58syf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 15:46:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22HFkPlj17957214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 15:46:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C11BFA405B;
        Thu, 17 Mar 2022 15:46:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC2FCA4062;
        Thu, 17 Mar 2022 15:46:24 +0000 (GMT)
Received: from sig-9-65-73-185.ibm.com (unknown [9.65.73.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Mar 2022 15:46:24 +0000 (GMT)
Message-ID: <64867453bee89d8ed8ec252a56f252ccdf624076.camel@linux.ibm.com>
Subject: Re: [PATCH v5 7/8] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 17 Mar 2022 11:46:24 -0400
In-Reply-To: <YhbePM/BiRCzL3bn@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-8-zohar@linux.ibm.com>
         <YhbePM/BiRCzL3bn@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TPeVpQAE3rL2Cj34e-OqqHrssUgxRrgs
X-Proofpoint-GUID: TPeVpQAE3rL2Cj34e-OqqHrssUgxRrgs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_06,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2022-02-23 at 17:24 -0800, Eric Biggers wrote:
> On Fri, Feb 11, 2022 at 04:43:09PM -0500, Mimi Zohar wrote:
> > Instead of calculating a regular file hash and verifying the signature
> > stored in the 'security.ima' xattr against the calculated file hash, get
> > fs-verity's file digest and verify the signature (version 3) stored in
> > 'security.ima' against the digest.
> > 
> > The policy rule 'appraise_type=' option is extended to support 'sigv3',
> > which is initiality limited to fs-verity.
> > 
> > The fs-verity 'appraise' rules are identified by the 'digest-type=verity'
> > option and require the 'appraise_type=sigv3' option.  The following
> > 'appraise' policy rule requires fsverity file digests.  (The rule may be
> > constrained, for example based on a fsuuid or LSM label.)
> > 
> > Basic fs-verity policy rule example:
> >   appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3
> > 
> > Lastly, for IMA to differentiate between the original IMA signature
> > from an fs-verity signature a new 'xattr_type' named IMA_VERITY_DIGSIG
> > is defined.
> 
> I'm having a hard time understanding this patch.  Can you please describe the
> motivation for doing things, not just the things themselves, and make sure the
> explanation is understandable to someone who isn't an IMA expert?

Ok, will be updated in the next version.

> 
> > diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> > index ff3c906738cb..508053b8dd0a 100644
> > --- a/Documentation/ABI/testing/ima_policy
> > +++ b/Documentation/ABI/testing/ima_policy
> > @@ -47,7 +47,7 @@ Description:
> >  			fgroup:= decimal value
> >  		  lsm:  are LSM specific
> >  		  option:
> > -			appraise_type:= [imasig] [imasig|modsig]
> > +			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
> >  			appraise_flag:= [check_blacklist]
> >  			Currently, blacklist check is only for files signed with appended
> >  			signature.
> > @@ -153,9 +153,27 @@ Description:
> >  
> >  			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
> >  
> > -		Example of 'measure' rule requiring fs-verity's digests on a
> > -		particular filesystem with indication of type of digest in
> > -		the measurement list.
> > +		Example of a 'measure' rule requiring fs-verity's digests
> > +		with indication of type of digest in the measurement list.
> >  
> >  			measure func=FILE_CHECK digest_type=verity \
> > -				fsuuid=... template=ima-ngv2
> > +				template=ima-ngv2
> > +
> > +		Example of 'measure' and 'appraise' rules requiring fs-verity
> > +		signatures (version 3) stored in security.ima xattr.
> > +
> > +		The 'measure' rule specifies the 'ima-sig' template option,
> > +		which includes the file signature in the measurement list.
> > +
> > +			measure func=BPRM_CHECK digest_type=verity \
> > +				template=ima-sig
> > +
> > +		The 'appraise' rule specifies the type and signature version
> > +		(sigv3) required.
> > +
> > +			appraise func=BPRM_CHECK digest_type=verity \
> > +				appraise_type=sigv3
> > +
> > +		All of these policy rules could, for example, be constrained
> > +		either based on a filesystem's UUID (fsuuid) or based on LSM
> > +		labels.
> 
> Is there documentation for what the appraise_type argument means, or does it
> just need to be reverse engineered from the above example?

The original definition was defined in Backus–Naur form.  Other
information was subsequently included which resulted in making it less
readable.  Perhaps for now, the explanation could be indented:

                        appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
                            where 'imasig' is the original or v2 signature,
                            where 'modsig' is an appended signature,
                            where 'sigv3' is the IMA v3 signature.

> 
> > + - 'sig': the file signature, based on either the file's/fsverity's digest[1],
> > +   or the EVM portable signature if the file signature is not found;
> 
> This sentence doesn't make sense.  How can it be the file signature if the
> "file signature is not found"?

EVM protects file metadata including security xattrs.  In order to make
EVM signatures portable, the i_ino and i_generation, which are
filesystem specific, couldn't be included.  Instead EVM portable
signature requires including 'security.ima', which may be a file hash
or signature.  Requiring both EVM and IMA signatures was considered
unnecessary, maybe even redundant.  When 'security.ima' is a file hash,
the 'sig' field may contain the EVM signature.

I've updated to be:
 - 'sig': the file signature, based on either the file's/fsverity's
digest[1],
   or the EVM portable signature, if 'security.ima' contains a file
hash.

> 
> > @@ -303,6 +321,12 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> >  	case EVM_IMA_XATTR_DIGSIG:
> >  		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> >  
> > +		if (iint->flags & (IMA_DIGSIG_REQUIRED | IMA_VERITY_REQUIRED)) {
> > +			*cause = "verity-signature-required";
> > +			*status = INTEGRITY_FAIL;
> > +			break;
> > +		}
> 
> Shouldn't this check whether *both* of these flags are set?

Yes, thank you.

> 
> > diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> > index 28aca1f9633b..d3006cc22ab1 100644
> > --- a/security/integrity/ima/ima_policy.c
> > +++ b/security/integrity/ima/ima_policy.c
> > @@ -1311,6 +1311,12 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
> >  	    !(entry->flags & IMA_MODSIG_ALLOWED))
> >  		return false;
> >  
> > +	/* Ensure APPRAISE verity file implies a v3 signature */
> > +	if (entry->action == APPRAISE &&
> > +	    (entry->flags & IMA_VERITY_REQUIRED) &&
> > +	    !(entry->flags & IMA_DIGSIG_REQUIRED))
> > +		return false;
> 
> This comment doesn't seem to match the code.h

Agreed, the comment will be updated in the next version.

> > diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> > index d370fca04de4..ecbe61c53d40 100644
> > --- a/security/integrity/ima/ima_template_lib.c
> > +++ b/security/integrity/ima/ima_template_lib.c
> > @@ -495,7 +495,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
> >  {
> >  	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
> >  
> > -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> > +	if (!xattr_value ||
> > +	    !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
> >  		return ima_eventevmsig_init(event_data, field_data);
> 
> This is OR-ing together values that aren't bit flags.

Updated.

thanks,

Mimi

